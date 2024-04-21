using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Windows.Navigation;
using static Find_Project.MainWindow;

namespace Find_Project.Utilities
{
    public static class FileOperations
    {
        // Helper function to update the ListBox with search results
        public static List<ListBoxItemMetadata> UpdateListBox(List<string> results, string searchContext)
        {
            List<ListBoxItemMetadata> items = new List<ListBoxItemMetadata>();

            foreach (string result in results)
            {
                // Add the result along with its search context as a hidden item
                items.Add(new ListBoxItemMetadata(result, searchContext));
            }

            return items;
        }

        // Utility function to get the full path of the selected item
        public static string GetFullPath(ListBoxItemMetadata selectedItem, AppSettings settings)
        {
            string path = selectedItem.SearchContext switch
            {
                "dirPathCtrl" => settings.DirPathCtrl,
                "dirPathShift" => settings.DirPathShift,
                _ => settings.DirPath
            };

            return Path.Combine(path, selectedItem.Text);
        }

        // Utility function to open a folder in Windows Explorer
        public static void OpenFolder(string folderName)
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

        // Utility function to open a folder browser dialog
        public static string? OpenFolderBrowserDialog()
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

        // Utility function to open a folder in Visual Studio Code
        public static string OpenFolderInVSCode(string fullPath)
        {

            try
            {
                // Open the folder in a new Visual Studio Code window
                Process.Start(new ProcessStartInfo
                {
                    FileName = "code",
                    Arguments = $"--new-window \"{fullPath}\"",
                    UseShellExecute = true
                });

                // Update the status bar
                return "Opened in Visual Studio Code: " + fullPath;
            }
            catch (Exception ex)
            {
                // Handle exception
                return "Error opening in Visual Studio Code: " + ex.Message;
            }
        }


        // Utility function to show an error message
        public static void ShowErrorMessage(string message)
        {
            MessageBox.Show(message);
        }

        // Utility function to get path based on keybind
        public static (string path, string searchContext, string searchContextText) PathByKeybind(AppSettings settings)
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

            return (path, searchContext, searchContextText);
        }
    }

    public class SearchService
    {
        public async Task<List<ListBoxItemMetadata>> PerformSearchAsync(string searchText, string path, int searchDepth, string searchContext)
        {
            // Perform the search and return the results
            Search search = new();
            List<string> results = await Search.SearchFoldersAsync(searchText, path, searchDepth);
            return Utilities.FileOperations.UpdateListBox(results, searchContext);
        }
    }
}

