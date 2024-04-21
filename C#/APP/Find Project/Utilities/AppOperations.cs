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
                "Activate the file-finding frenzy!",
                "Let's dig into your digital treasure trove!",
                "Ready to wrangle those wandering files?",
                "Cue the drumroll! Let's find those files!",
                "Prepare to conquer your digital chaos!",
                "Time to bring order to the digital mayhem!",
                "Let's turn your file jungle into a file paradise!",
                "On your mark, get set, organize!",
                "Grab your virtual flashlight! We're exploring your files!",
                "Let's navigate the labyrinth of your folders!",
                "Blast off into the realm of organized files!",
                "Unveil the hidden gems buried in your folders!",
                "Prepare for a digital scavenger hunt!",
                "Ready to untangle the web of files?",
                "Let's be the heroes your files deserve!",
                "Welcome to the land of file-finding wonders!",
                "Brace yourself for a file-finding odyssey!",
                "Let's sprinkle some organization magic!",
                "Get your file-finding engines revved!",
                "Onward, to the land of organized bliss!",
                "Charting a course through your file galaxy!",
                "Let's embark on a journey to file serenity!",
                "Dive into the sea of your digital documents!",
                "Let's give your files the spotlight they deserve!",
                "Buckle up for a rollercoaster ride through your files!",
                "Ready to bring order to the file chaos?",
                "Prepare for file-finding greatness!",
                "Let's dust off those neglected files and give them a home!",
                "File-finding mode: activated!",
                "Let's make file-finding an art form!",
                "Your files called—they're ready to be found!",
                "Navigate the file maze with finesse!",
                "We're on a mission to rescue your lost files!",
                "Time to shine a light on your file darkness!",
                "Let's crack the code of your file organization!",
                "Embrace the thrill of the file hunt!",
                "Prepare to witness the magic of file-finding!",
                "Welcome to the file-finding party!",
                "Your files are waiting for their moment in the sun!",
                "Let's tame the file chaos like a digital cowboy!",
                "Clear the clutter, find the files!",
                "We're the file-finding dream team!",
                "Let's turn your file frown upside down!",
                "Ready to decode the language of your files?",
                "Let's play matchmaker with your files and folders!",
                "Unleash the power of your organized files!",
                "Let's uncover the buried treasures in your folders!",
                "Your files are our top priority!",
                "We're on a quest for file-finding glory!",
                "Prepare for a file-finding revolution!",
                "Let's make your file dreams a reality!",
            };
            Random random = new();
            int index = random.Next(statusMessages.Count);
            return statusMessages[index];
        }

    }

}
