using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace Find_Project
{
    public class Search
    {
        public async Task<List<string>> SearchFoldersAsync(string query, string dirPath)
        {
            List<string> results = new List<string>();

            // Check if the query contains at least 3 characters
            if (query.Length < 3)
            {
                throw new ArgumentException("Input must contain at least 3 characters");
            }

            await Task.Run(() =>
            {
                // Filter for folders and add to results list
                string[] folders = Directory.GetDirectories(dirPath, "*" + query + "*", SearchOption.AllDirectories);
                foreach (string folder in folders)
                {
                    // Get relative path by removing the default path
                    string relativePath = folder.Replace(dirPath, "");
                    results.Add(relativePath);
                }

                // Sort the results list alphanumerically
                results.Sort();
            });

            return results;
        }
    }
}
