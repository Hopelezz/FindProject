
import os

# Set Default Folder Path to search
defaultPath = "E:\\CodeBase\\" # Change this to your default folder path

while True:
    # Prompt user for folder path
    searchInput = input("Enter Folder Name: ")
    # If user enters nothing, use default path
    if searchInput == "":
        print("Input must container 3 Characters")
    # If searchInput is less than 3 characters close the program else continue
    if len(searchInput) < 3:
        print("Please enter at least 3 characters")
    else:
        index = 1
        folderDict = {}
        for folderName in os.listdir(defaultPath):
            if searchInput in folderName:
                folderDict[index] = os.path.join(defaultPath, folderName)
                index += 1
        if len(folderDict) == 0:
            print("Folder Not Found")
        else:
            # Print the hash table
            for key, value in folderDict.items():
                print(key, value)
            # Prompt user for selection
            selection = input("Select Index Number: ")
            # If selection is not a number or is not in the hash table print "Invalid Selection"
            if selection.isdigit() == False or int(selection) not in folderDict:
                print("Invalid Selection")
            else:
                # If selection is a number and in the hash table print the full path
                print(folderDict[int(selection)])

        
