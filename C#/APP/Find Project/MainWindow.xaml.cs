using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Find_Project
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            ChangeTheme("DarkTheme"); // Set a default theme

            InitializeComponent();
        }
        private void ChangeTheme(string newTheme)
        {
            //create a new resource dictionary
            var dict = new ResourceDictionary();

            //set the source of the dictionary to the theme file
            dict.Source = new Uri("Themes/" + newTheme + ".xaml", UriKind.Relative);

            //remove the old theme and add the new one
            Application.Current.Resources.MergedDictionaries.Clear();
            Application.Current.Resources.MergedDictionaries.Add(dict);
        }
        private void ThemeComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var comboBox = (ComboBox)sender;
            var selectedTheme = (string)((ComboBoxItem)comboBox.SelectedItem).Content;

            ChangeTheme(selectedTheme);
        }
                private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
        private void MinimizeButton_Click(object sender, RoutedEventArgs e)
        {
            this.WindowState = WindowState.Minimized;
        }
    }
}
