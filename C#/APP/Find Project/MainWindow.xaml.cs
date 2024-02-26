using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace Find_Project
{
    public partial class MainWindow : Window
    {

        private string dirPath; // Default dirPath
        private string dirPathAlt = @"D:\"; // Alternate directory path for Alt+Enter search
        private string settingsFilePath = @"C:\TEMP\FindProjectSetting.txt";
        private string defaultPath;


        private Search search = new Search();
        private List<string> lastSearchResult;

        public MainWindow()
        {
            InitializeComponent();
            LoadSettings();
            //InitializeThemes();
        }


//       private void InitializeThemes()
//       {
//           // Populate themeComboBox with available themes
//          List<string> themes = new List<string> { "Light", "Dark" }; // Add your themes here
//          themeComboBox.ItemsSource = themes;
//       }

        private void SearchBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                PerformSearch();
            }
            else if (Keyboard.IsKeyDown(Key.LeftAlt) && e.Key == Key.Enter)
            {
                // Handle Alt+Enter search
                try
                {
                    if (!string.IsNullOrEmpty(dirPathAlt) && Directory.Exists(dirPathAlt))
                    {
                        Process.Start("explorer.exe", dirPathAlt);
                    }
                    else
                    {
                        MessageBox.Show("Unable to locate the specified directory.");
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error opening directory: " + ex.Message);
                }
            }
        }

        private void SearchButton_Click(object sender, RoutedEventArgs e)
        {
            PerformSearch();
        }

        private async void PerformSearch()
        {
            try
            {
                Search search = new Search();
                List<string> results = await search.SearchFoldersAsync(searchBox.Text, dirPath);

                listBox.Items.Clear(); // Clear existing items before adding new ones
                foreach (string result in results)
                {
                    // Prepend the default path back to the relative path
                    string fullPath = Path.Combine(dirPath, result);
                    listBox.Items.Add(fullPath);
                }
            }
            catch (ArgumentException ex)
            {
                warningLabel.Content = ex.Message;
            }
            catch (Exception ex)
            {
                MessageBox.Show("An error occurred: " + ex.Message);
            }
        }


        private void ListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            string selectedItem = listBox.SelectedItem as string;
            if (selectedItem != null)
            {
                // Get the full path of the selected folder
                string fullPath = Path.Combine(dirPath, selectedItem);

                try
                {
                    // Open the selected folder
                    Process.Start("explorer.exe", fullPath);
                }
                catch (Exception ex)
                {
                    // Handle exception
                    MessageBox.Show("Error opening folder: " + ex.Message);
                }
            }
        }

        private void UpdateListBox(List<string> results)
        {
            listBox.Items.Clear();
            foreach (string result in results)
            {
                listBox.Items.Add(result);
            }
        }

        private void ListBox_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            string selectedItem = listBox.SelectedItem as string;
            if (selectedItem != null)
            {
                // Combine dirPath with the selected folder name to get the full path
                string fullPath = Path.Combine(dirPath, selectedItem);

                try
                {
                    // Open the folder or navigate to it if already open
                    OpenFolder(selectedItem);
                }
                catch (Exception ex)
                {
                    // Handle exception
                    MessageBox.Show("Error opening folder: " + ex.Message);
                }
            }
        }

        private void OpenFolder(string folderName)
        {
            if (lastSearchResult != null && lastSearchResult.Contains(folderName))
            {
                // Combine dirPath with the folder name to get the full path
                string fullPath = Path.Combine(dirPath, folderName);

                try
                {
                    // Open the folder
                    Process.Start("explorer.exe", fullPath);
                }
                catch (Exception ex)
                {
                    // Handle exception
                    MessageBox.Show("Error opening folder: " + ex.Message);
                }
            }
            else
            {
                MessageBox.Show("The folder does not exist or was not found in the last search result.");
            }
        }

// SETTINGS
        private void LoadSettings()
        {
            if (File.Exists(settingsFilePath))
            {
                dirPath = File.ReadAllText(settingsFilePath);
                if (string.IsNullOrWhiteSpace(defaultPath))
                {
                    dirPath = @"C:\";
                }
            }
            else
            {
                dirPath = @"C:\";
            }
        }

        private void SaveSettings()
        {
            defaultPath = defaultPathTextBox.Text.Trim();
            File.WriteAllText(settingsFilePath, defaultPath);
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Set dirPath to the text in defaultPathTextBox
                dirPath = defaultPathTextBox.Text.Trim();

                // Save the dirPath to the settings file
                SaveSettings();

                MessageBox.Show("Settings saved successfully.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error saving settings: " + ex.Message);
            }
        }

    }
}


