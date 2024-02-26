using System;
using System.Collections.Generic;
using System.IO;

namespace Find_Project
{
    public class Search
    {
        public string dirPath = @"E:\";
        public string logPath = @"C:\TEMP\FindProject\ErrorLog.txt";
        public string dirPath2 = @"D:\"; // Directory path for Alt+Enter search

        public List<string> SearchFolders(string query, string dirPath)
        {
            // Ensure dirPath is not null or empty
            if (string.IsNullOrEmpty(dirPath))
            {
                throw new ArgumentException("Directory path cannot be null or empty.");
            }

            List<string> results = new List<string>();

           
            // Perform search in the specified directory path
            string[] directories = Directory.GetDirectories(dirPath, $"*{query}*");

            foreach (string directory in directories)
            {
                // Get the folder name
                string folderName = Path.GetFileName(directory);
                results.Add(folderName);
            }

            return results;
        }

        public List<string> SearchFoldersAltEnter()
        {
            List<string> results = new List<string>();

            // Perform search in the alternate directory path
            string[] directories = Directory.GetDirectories(dirPath2);

            foreach (string directory in directories)
            {
                // Get the folder name
                string folderName = Path.GetFileName(directory);
                results.Add(folderName);
            }

            return results;
        }

        public void LogError(Exception ex)
        {
            // Log the error to the specified log file
            using (StreamWriter writer = new StreamWriter(logPath, true))
            {
                writer.WriteLine($"[{DateTime.Now}] {ex.Message}");
            }
        }
    }
}
