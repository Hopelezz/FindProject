using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class MainForm : Form
{
    // Define controls here
    private TextBox searchBox;
    private Button searchButton;
    private ListBox listBox;
    private Label warningLabel;

    // Define paths
    private string dirPath = @"E:\";
    private string logPath = @"E:\CodeBase\FindProject\GUI\LOG\ErrorLog.txt"; // Add the log path
    private string vsPath = @"C:\Users\panze\AppData\Local\Programs\Microsoft VS Code\Code.exe";

    // Add a field for ProjectSearcher
    private ProjectSearcher projectSearcher;

    public MainForm()
    {
        // Instantiate ProjectSearcher
        projectSearcher = new ProjectSearcher(dirPath, logPath);
        InitializeComponent();
    }

    private void InitializeComponent()
    {
        // Initialize and set up controls
        // This includes setting sizes, locations, and event handlers
        this.searchBox = new TextBox();
        this.searchButton = new Button();
        this.listBox = new ListBox();
        this.warningLabel = new Label();

        // Example: Setting properties for searchButton
        this.searchButton.Text = "Search";
        this.searchButton.Click += new EventHandler(this.SearchButton_Click);

        // Add controls to the form
        this.Controls.Add(this.searchBox);
        this.Controls.Add(this.searchButton);
        this.Controls.Add(this.listBox);
        this.Controls.Add(this.warningLabel);

        // Other form initialization here...
    }

    private void SearchButton_Click(object sender, EventArgs e)
    {
        listBox.Items.Clear();
        var projects = projectSearcher.SearchForProjects(searchBox.Text);
        foreach (var project in projects)
        {
            listBox.Items.Add(project);
        }

        if (listBox.Items.Count == 0)
        {
            warningLabel.Text = "No folders found";
            warningLabel.Visible = true;
        }
        else
        {
            warningLabel.Visible = false;
        }
    }

    [DllImport("kernel32.dll")]
    static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    public static void HideConsole()
    {
        var handle = GetConsoleWindow();
        // Hide console window
        ShowWindow(handle, 0);
    }

    public static void ShowConsole()
    {
        var handle = GetConsoleWindow();
        // Show console window
        ShowWindow(handle, 4);
    }

    static void Main()
    {
        HideConsole();
        Application.Run(new MainForm());
    }
}
