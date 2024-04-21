using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace Find_Project
{
    public class Search
    {
        public static async Task<List<string>> SearchFoldersAsync(string query, string dirPath)
        {
            List<string> results = new();

            // Check if the query contains at least 3 characters
            if (query.Length < 3)
            {
                throw new ArgumentException("Input must contain at least 3 characters");
            }

            try
            {
                await Task.Run(() =>
                {
                    SearchInLevel(results, dirPath, query, 0, "");
                });
            }
            catch (Exception ex)
            {
                // Handle other exceptions
                Console.WriteLine(ex.Message);
            }

            return results;
        }

        private static void SearchInLevel(List<string> results, string dirPath, string query, int level, string currentRelativePath)
        {
            if (level > 1) // Limit search to two levels deep
                return;

            try
            {
                foreach (var directory in Directory.EnumerateDirectories(dirPath))
                {
                    // Check if the directory name contains the query string
                    if (directory.Contains(query, StringComparison.OrdinalIgnoreCase))
                    {
                        // Get the relative path of the directory
                        string relativePath = Path.Combine(currentRelativePath, Path.GetFileName(directory));

                        // Add the relative path to the results list
                        results.Add(relativePath);
                    }

                    // Recursively search in the next level
                    SearchInLevel(results, directory, query, level + 1, Path.Combine(currentRelativePath, Path.GetFileName(directory)));
                }
            }
            catch (UnauthorizedAccessException)
            {
                // Skip directories that the user doesn't have access to
                return;
            }
        }
    }
}
