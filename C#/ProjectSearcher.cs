using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;

public class ProjectSearcher
{
    private string dirPath;
    private string logPath;

    public ProjectSearcher(string dirPath, string logPath)
    {
        this.dirPath = dirPath;
        this.logPath = logPath;
    }

    public List<string> SearchForProjects(string searchTerm)
    {
        List<string> foundProjects = new List<string>();
        if (searchTerm.Length < 3)
        {
            MessageBox.Show("Input must contain at least 3 characters", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
        else
        {
            try
            {
                DirectoryInfo dirInfo = new DirectoryInfo(this.dirPath);
                foreach (DirectoryInfo dir in dirInfo.GetDirectories("*" + searchTerm + "*", SearchOption.AllDirectories))
                {
                    foundProjects.Add(dir.FullName);
                }
            }
            catch (Exception ex)
            {
                LogError(ex.Message);
            }
        }
        return foundProjects;
    }

    public void LogError(string message)
    {
        if (!File.Exists(logPath))
        {
            using (File.Create(logPath)) { }
        }

        using (StreamWriter writer = new StreamWriter(logPath, true))
        {
            writer.WriteLine($"{DateTime.Now}: {message}");
        }

        MessageBox.Show("An error occurred. Please check the log file for more details.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
    }
}
