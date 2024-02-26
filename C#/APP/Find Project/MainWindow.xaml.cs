﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace Find_Project
{
    public partial class MainWindow : Window
    {

        private string dirPath; // Default dirPath
        private string dirPathCtrl; // Alternate directory path for Alt+Enter search
        private string settingsFilePath = @"C:\TEMP\FindProjectSetting.txt";

        private List<string> lastSearchResult = new();


        public MainWindow()
        {
            InitializeComponent();
            LoadSettings();
        }

        // SEARCH FUNCTIONS
        private void SearchBox_KeyDown(object sender, KeyEventArgs e)
        {
            if(dirPath == null || dirPathCtrl == null)
            {
                MessageBox.Show("Please set the default and alternate directory paths in settings.");
                return;
            }
            else {
                // Control + Enter to search in alternate directory
                if (Keyboard.IsKeyDown(Key.LeftCtrl) && e.Key == Key.Enter)
                {
                    PerformSearch(dirPathCtrl);
                }
                else if (e.Key == Key.Enter)
                {
                    PerformSearch(dirPath);
                }
            }
        }

        private void SearchButton_Click(object sender, RoutedEventArgs e)
        {
            PerformSearch(dirPath);
        }

        private async void PerformSearch(string path)
        {
            try
            {
                Search search = new();
                List<string> results = await Search.SearchFoldersAsync(searchBox.Text, path);

                UpdateListBox(results);
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
                MessageBox.Show("An error occurred: " + ex.Message);
            }

        }


        private void ListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (listBox.SelectedItem is string selectedItem)
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
            listBox.Items.Clear(); // Clear existing items before adding new ones
            foreach (string result in results)
            {
                // Prepend the default path back to the relative path
                string fullPath = Path.Combine(dirPath, result);
                listBox.Items.Add(fullPath);
            }
        }

        private void ListBox_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            if (listBox.SelectedItem is string selectedItem)
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
                using StreamReader reader = new(settingsFilePath);
                {
                    string? line;
                    while ((line = reader.ReadLine()) != null)
                    {
                        string[] parts = line.Split(new char[] { ':' }, 2, StringSplitOptions.RemoveEmptyEntries);
                        if (parts.Length == 2)
                        {
                            string varName = parts[0].Trim();
                            string value = parts[1].Trim();
                            // Assign values to variables based on variable name
                            switch (varName)
                            {
                                case "dirPath":
                                    dirPath = value;
                                    defaultPathTextBox.Text = value; // Set text of the TextBox
                                    break;
                                case "dirPathCtrl":
                                    dirPathCtrl = value; // Set dirPathCtrl value
                                    ctrlPathTextBox.Text = value; // Set text of the TextBox
                                    break;
                            }
                        }
                    }
                }
            }
            else // If settings file doesn't exist, set passive text
            {
                dirPath = "C:\\";
                dirPathCtrl = "C:\\";
                defaultPathTextBox.Text = "Enter default path...";
                defaultPathTextBox.Foreground = Brushes.LightGray; // Set passive text color
                ctrlPathTextBox.Text = "Enter CTRL+Enter path...";
                ctrlPathTextBox.Foreground = Brushes.LightGray; // Set passive text color
            }
        }


        private void SaveSettings()
        {
            using StreamWriter writer = new(settingsFilePath);
            {
                writer.WriteLine("dirPath: " + dirPath);
                writer.WriteLine("dirPathCtrl: " + dirPathCtrl);
                // Add more variables if needed
            }
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // Set dirPath to the text in defaultPathTextBox
                dirPath = defaultPathTextBox.Text.Trim();
                // Set dirPathCtrl to the text in ctrlPathTextBox
                dirPathCtrl = ctrlPathTextBox.Text.Trim();

                // Save the dirPath to the settings file
                SaveSettings();

                MessageBox.Show("Settings saved successfully.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error saving settings: " + ex.Message);
            }
        }

        private void TextBox_GotFocus(object sender, RoutedEventArgs e)
        {
            if (sender is TextBox textBox && (string)textBox.Tag == "Placeholder")
            {
                textBox.Text = "";
                textBox.Foreground = Brushes.Black; // Set text color to black when typing
            }
        }

        private void TextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (sender is TextBox textBox && string.IsNullOrWhiteSpace(textBox.Text))
            {
                string placeholderText = (string)textBox.Tag;
                textBox.Text = placeholderText;
                textBox.Foreground = Brushes.LightGray; // Set text color to light gray when placeholder
            }
        }

    } // End of MainWindow class
}


