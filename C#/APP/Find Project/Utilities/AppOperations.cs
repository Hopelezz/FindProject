using System;
using System.Collections.Generic;
using System.Windows.Controls;
using static Find_Project.MainWindow;

namespace Find_Project.Utilities
{
    public class AppOperations
    {
        // Helper function to update the text boxes with the settings values
        public void UpdateSettingsTextBoxes(AppSettings settings, TextBox defaultPathTextBox, TextBox ctrlPathTextBox, TextBox shiftPathTextBox)
        {
            defaultPathTextBox.Text = settings.DirPath;
            ctrlPathTextBox.Text = settings.DirPathCtrl;
            shiftPathTextBox.Text = settings.DirPathShift;
        }

        // Helper function to update the ListBox with search results
        public void UpdateListBox(List<ListBoxItemMetadata> items, ListBox listBox, TextBlock statusMessage)
        {
            listBox.Items.Clear();
            foreach (var item in items)
            {
                listBox.Items.Add(item);
            }

            if (listBox.Items.Count == 0)
            {
                statusMessage.Text = "No items found.";
            }
        }


        // Create a list of status messages to display in the status bar
        public string RandomStatusMessage()
        {

        List<string> statusMessages = new()
            {
                "Ready for a file-finding adventure?",
                "Let's find those files!",
                "Let's play hide and seek with your files!",
                "Time to uncover your digital universe!",
                "Let's get this party started!",
                "Who needs a treasure map?",
                "Lights, camera, action!",
                "Your mission: find those files!",
                "Let's hunt some digital gold!",
                "Get your searching hats on!",
                "Let's turn chaos into bliss!",
                "Welcome aboard the file-finding express!",
                "Clear eyes, full hard drives!",
                "Your files called. Let's find them!",
                "Sherlock who? Let's do this!",
                "Ready, set, search!",
                "Fear not, we'll guide you through!",
                "Let's unleash the power of organization!",
                "Forecast: scattered files, chance of organization!",
                "Don your explorer's hat!",
                "Operation: Find & Restore, commence!",
                "Get ready for file-finding fireworks!",
                "Time to tame the wild beast of your file system!",
                "Unlock the hidden potential of your files!",
                "Prepare for file-finding fireworks!",
                "Let's turn chaos into clarity!",
                "Adventure awaits at every click!",
                "Dive headfirst into the digital rabbit hole!",
                "Hold onto your hats, folks!",
                "Files await their moment in the spotlight!",
                "Let's sprinkle some magic dust on your files!",
                "Navigate the twists and turns of your file maze!",
                "Show those folders who's boss!",
                "We're marching into battle against disorganization!",
                "We're on a mission to conquer clutter!",
                "Let's dive into the digital unknown!",
                "Clear the runway for a file-finding adventure!",
                "Files, here we come!",
                "Venture into the digital wilderness!",
                "Get ready for a file-finding extravaganza!",
                "Sprinkle some organization fairy dust!",
                "Rev up for a file-finding marathon!",
                "Dive deep into the digital depths!",
                "Solve the mystery of the missing files!",
                "Embark on a wild ride through your directories!",
                "Crack open those virtual vaults!",
                "Witness the magic of organization!",
                "Activate the file-finding frenzy!"
            };
            Random random = new();
            int index = random.Next(statusMessages.Count);
            return statusMessages[index];
        }

    }

}
