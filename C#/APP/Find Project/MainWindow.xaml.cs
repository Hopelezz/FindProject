using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Controls.Primitives;
using System.Windows.Forms;
using System.Windows.Input;

namespace Find_Project
{
    public partial class MainWindow : Window
    {
        private readonly AppSettings settings = new();

        public MainWindow()
        {
            InitializeComponent();

            // Update the text boxes with the loaded settings
            defaultPathTextBox.Text = settings.DirPath;
            ctrlPathTextBox.Text = settings.DirPathCtrl;
            shiftPathTextBox.Text = settings.DirPathShift;
        }

// SEARCH FUNCTIONS
        // KeyDown event handler for the search box
        private void SearchBox_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                SearchButton_Click(sender, e);
            }
        }

        private void SearchButton_Click(object sender, RoutedEventArgs e)
        {
            string path;
            string searchContext;
            string searchContextText;

            if (System.Windows.Forms.Control.ModifierKeys == Keys.Control)
            {
                path = settings.DirPathCtrl;
                searchContext = "dirPathCtrl";
                searchContextText = "Ctrl+Enter";
            }
            else if (System.Windows.Forms.Control.ModifierKeys == Keys.Shift)
            {
                path = settings.DirPathShift;
                searchContext = "dirPathShift";
                searchContextText = "Shift+Enter";
            }
            else
            {
                path = settings.DirPath;
                searchContext = "dirPath";
                searchContextText = "Default Path";
            }

            if (string.IsNullOrEmpty(path))
            {
                System.Windows.MessageBox.Show($"Please set the {searchContextText} in settings.");
                return;
            }
            // Update status bar
            statusMessage.Text = $"{searchContext} | Directory: {path}";

            PerformSearch(path, searchContext);
        }

        // Helper function to perform the search
        private async void PerformSearch(string path, string searchContext)
        {
            // Check if the path is empty
            if (string.IsNullOrEmpty(path))
            {
                warningLabel.Content = "Please set a directory path in settings before searching.";
                return;
            }
            try
            {
                Search search = new();
                List<string> results = await Search.SearchFoldersAsync(searchBox.Text, path, settings.SearchDepth);

                UpdateListBox(results, searchContext);
                // Remove any previous warning messages
                warningLabel.Content = "";
            }
            catch (UnauthorizedAccessException)
            {
                // Set warning message
                warningLabel.Content = "Access denied. Try running the application as an administrator.";
            }
            catch (ArgumentException ex)
            {
                warningLabel.Content = ex.Message;
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show("An error occurred: " + ex.Message);
            }
        }

        private void UpdateListBox(List<string> results, string searchContext)
        {
            listBox.Items.Clear(); // Clear existing items before adding new ones
            foreach (string result in results)
            {
                // Add the result along with its search context as a hidden item
                listBox.Items.Add(new ListBoxItemMetadata(result, searchContext));
            }
        }

        // ListBoxItemMetadata class to store the text and search context of each item
        public class ListBoxItemMetadata
        {
            public string Text { get; }
            public string SearchContext { get; }

            public ListBoxItemMetadata(string text, string searchContext)
            {
                Text = text;
                SearchContext = searchContext;
            }

            public override string ToString()
            {
                return Text;
            }
        }

        private void ListBox_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            if (listBox.SelectedItem is ListBoxItemMetadata selectedItem)
            {
                string fullPath = Path.Combine(selectedItem.SearchContext switch
                {
                    "dirPathCtrl" => settings.DirPathCtrl,
                    "dirPathShift" => settings.DirPathShift,
                    _ => settings.DirPath
                }, selectedItem.Text);

                try
                {
                    // Open the folder or navigate to it if already open
                    OpenFolder(fullPath);
                }
                catch (Exception ex)
                {
                    // Handle exception
                    System.Windows.Forms.MessageBox.Show("Error opening folder: " + ex.Message);
                }
            }
        }

        // Utility function to open a folder in Windows Explorer
        private static void OpenFolder(string folderName)
        {
            // Ensure the folder name is not null or empty
            if (!string.IsNullOrEmpty(folderName))
            {
                try
                {
                    // Open the folder using Process.Start
                    Process.Start("explorer.exe", folderName);
                }
                catch (Exception ex)
                {
                    // Handle exception
                    System.Windows.Forms.MessageBox.Show("Error opening folder: " + ex.Message);
                }
            }
            else
            {
                System.Windows.Forms.MessageBox.Show("Folder name is null or empty.");
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Set the settings values from the text boxes and slider
                settings.DirPath = defaultPathTextBox.Text.Trim();
                settings.DirPathCtrl = ctrlPathTextBox.Text.Trim();
                settings.DirPathShift = shiftPathTextBox.Text.Trim();
                // Set SearchDepth to the value of the slider
                settings.SearchDepth = (int)searchDepthSlider.Value;

                // Save the dirPath to the settings file
                settings.SaveSettings();

                // Update the status bar
                statusMessage.Text = "Settings saved successfully.";
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show("Error saving settings: " + ex.Message);
            }

        }

        // Utility function to open a folder browser dialog
        private static string? OpenFolderBrowserDialog()
        {
            // Create a new folder browser dialog
            using var dialog = new FolderBrowserDialog();
            {
                // Set the description and root folder (optional)
                dialog.Description = "Select the default path:";
                dialog.RootFolder = Environment.SpecialFolder.MyComputer;

                // Show the dialog and get the result
                DialogResult result = dialog.ShowDialog();

                // If the user selects a folder, return the selected path
                if (result == System.Windows.Forms.DialogResult.OK)
                {
                    return dialog.SelectedPath;
                }
                else
                {
                    return null; // User cancelled or closed the dialog
                }
            }
        }

        private void DefaultPathButton_Click(object sender, RoutedEventArgs e)
        {
            // Open a folder browser dialog to select the default path and set the text box
            string? selectedPath = OpenFolderBrowserDialog();
            if (!string.IsNullOrEmpty(selectedPath))
            {
                defaultPathTextBox.Text = selectedPath;
            }
        }

        private void CtrlPathButton_Click(object sender, RoutedEventArgs e)
        {
            // Open a folder browser dialog to select the default path and set the text box
            string? selectedPath = OpenFolderBrowserDialog();
            if (!string.IsNullOrEmpty(selectedPath))
            {
                ctrlPathTextBox.Text = selectedPath;
            }
        }

        private void ShiftPathButton_Click(object sender, RoutedEventArgs e)
        {
            // Open a folder browser dialog to select the default path and set the text box
            string? selectedPath = OpenFolderBrowserDialog();
            if (!string.IsNullOrEmpty(selectedPath))
            {
                shiftPathTextBox.Text = selectedPath;
            }
        }

    } // End of MainWindow class
}
