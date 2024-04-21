using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace Find_Project
{
    public class AppSettings
    {
        public string DirPath { get; set; } // Default dirPath
        public string DirPathCtrl { get; set; } // Alternate directory path for CTRL+Enter search
        public string DirPathShift { get; set; } // Alternate directory path for Shift+Enter search
        public string SettingsFilePath { get; set; }

        public AppSettings()
        {
            // Create folder inside User Documents and place settings.txt file inside
            string seekerFolderPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "Seeker");
            Directory.CreateDirectory(seekerFolderPath); // Create the "Seeker" folder if it doesn't exist
            SettingsFilePath = Path.Combine(seekerFolderPath, "settings.txt");

            // Set Default values. Will be overwritten if settings file exists
            DirPath = "C:\\";
            DirPathCtrl = "";
            DirPathShift = "";

            LoadSettings();
        }


        // SETTINGS
        private void LoadSettings()
        {
            if (File.Exists(SettingsFilePath))
            {
                using StreamReader reader = new(SettingsFilePath);
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
                                    DirPath = value;
                                    break;
                                case "dirPathCtrl":
                                    DirPathCtrl = value;
                                    break;
                                case "dirPathShift":
                                    DirPathShift = value;
                                    break;
                            }
                        }
                    }
                }
            }
        }

        public void SaveSettings()
        {
            using StreamWriter writer = new(SettingsFilePath);
            {
                writer.WriteLine("dirPath: " + DirPath);
                writer.WriteLine("dirPathCtrl: " + DirPathCtrl);
                writer.WriteLine("dirPathShift: " + DirPathShift);
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
    }
}

