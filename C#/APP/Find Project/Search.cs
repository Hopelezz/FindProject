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
                    foreach (var directory in Directory.EnumerateDirectories(dirPath))
                    {
                        try
                        {
                            // Filter for folders and add to results list
                            string[] folders = Directory.GetDirectories(directory, "*" + query + "*", SearchOption.AllDirectories);
                            foreach (string folder in folders)
                            {
                                // Get relative path by removing the default path
                                string relativePath = folder.Replace(dirPath, "");
                                results.Add(relativePath);
                            }
                        }
                        catch (UnauthorizedAccessException)
                        {
                            // Skip folders that the user doesn't have access to
                            continue;
                        }
                    }

                    // Sort the results list alphanumerically
                    results.Sort();
                });
            }
            catch (Exception ex)
            {
                // Handle other exceptions
                Console.WriteLine(ex.Message);
            }

            return results;
        }
    }
}
