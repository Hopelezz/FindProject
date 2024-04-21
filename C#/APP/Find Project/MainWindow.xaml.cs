using Find_Project.Utilities;
using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Input;

namespace Find_Project
{
    public partial class MainWindow : Window
    {
        private readonly AppSettings settings = new();
        private readonly AppOperations appOperations = new();


        public MainWindow()
        {
            InitializeComponent();
            appOperations.UpdateSettingsTextBoxes(settings, defaultPathTextBox, ctrlPathTextBox, shiftPathTextBox);
            InitializeListBox();
            statusMessage.Text = appOperations.RandomStatusMessage();
        }

        private void InitializeListBox()
        {
            List<ListBoxItemMetadata> items = new List<ListBoxItemMetadata>();
            appOperations.UpdateListBox(items, listBox, statusMessage);
        }


        // Helper function to open the folder of the selected item
        private void OpenFolder(ListBoxItemMetadata selectedItem)
        {
            if (selectedItem != null)
            {
                string fullPath = Utilities.FileOperations.GetFullPath(selectedItem, settings);
                try
                {
                    Utilities.FileOperations.OpenFolder(fullPath);
                    statusMessage.Text = $"Opened folder: {fullPath}";
                }
                catch (Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show($"Error opening folder: {ex.Message}");
                }
            }
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

        private async void SearchButton_Click(object sender, RoutedEventArgs e)
        {
            var (path, searchContext, searchContextText) = Utilities.FileOperations.PathByKeybind(settings);

            if (string.IsNullOrEmpty(path))
            {
                System.Windows.MessageBox.Show($"Please set the {searchContextText} in settings.");
                return;
            }
            // Update status bar
            statusMessage.Text = $"{searchContextText} | Directory: {path}";

            try
            {
                SearchService searchService = new();
                List<ListBoxItemMetadata> items = await searchService.PerformSearchAsync(searchBox.Text, path, settings.SearchDepth, searchContext);

                // Update the ListBox with the search results
                appOperations.UpdateListBox(items, listBox, statusMessage);

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


        private void ListBox_MouseDoubleClick(object sender, MouseButtonEventArgs? e)
        {
            if (listBox.SelectedItem is ListBoxItemMetadata selectedItem)
            {
                OpenFolder(selectedItem);
            }
        }

        private void Open_Click(object sender, RoutedEventArgs e)
        {
            // Perform the same action as double-clicking on the selected item
            ListBox_MouseDoubleClick(sender, null);
        }

        private void VisualStudio_Click(object sender, RoutedEventArgs e)
        {
            // Open the selected item in Visual Studio Code

            if (listBox.SelectedItem is ListBoxItemMetadata selectedItem)
            {
                string fullPath = Utilities.FileOperations.GetFullPath(selectedItem, settings);
                Utilities.FileOperations.OpenFolderInVSCode(fullPath);

                // Update the status bar using the returned message
                statusMessage.Text = Utilities.FileOperations.OpenFolderInVSCode(fullPath);
            }
        }

        private void Properties_Click(object sender, RoutedEventArgs e)
        {
            // Open the properties window for the selected item
            if (listBox.SelectedItem is ListBoxItemMetadata selectedItem)
            {
                string fullPath = Utilities.FileOperations.GetFullPath(selectedItem, settings);

                // Open the properties window using ShellExecute.cs
                ShellExecute.SHELLEXECUTEINFO info = new ShellExecute.SHELLEXECUTEINFO();
                info.cbSize = System.Runtime.InteropServices.Marshal.SizeOf(info);
                info.lpVerb = "properties";
                info.lpFile = fullPath;
                info.nShow = ShellExecute.SW_SHOW;
                info.fMask = ShellExecute.SEE_MASK_INVOKEIDLIST;
                ShellExecute.ShellExecuteEx(ref info);
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



        private void DefaultPathButton_Click(object sender, RoutedEventArgs e)
        {
            // Open a folder browser dialog to select the default path and set the text box
            string? selectedPath = Utilities.FileOperations.OpenFolderBrowserDialog();
            if (!string.IsNullOrEmpty(selectedPath))
            {
                defaultPathTextBox.Text = selectedPath;
            }
        }

        private void CtrlPathButton_Click(object sender, RoutedEventArgs e)
        {
            // Open a folder browser dialog to select the default path and set the text box
            string? selectedPath = Utilities.FileOperations.OpenFolderBrowserDialog();
            if (!string.IsNullOrEmpty(selectedPath))
            {
                ctrlPathTextBox.Text = selectedPath;
            }
        }

        private void ShiftPathButton_Click(object sender, RoutedEventArgs e)
        {
            // Open a folder browser dialog to select the default path and set the text box
            string? selectedPath = Utilities.FileOperations.OpenFolderBrowserDialog();
            if (!string.IsNullOrEmpty(selectedPath))
            {
                shiftPathTextBox.Text = selectedPath;
            }
        }

    } // End of MainWindow class
}
