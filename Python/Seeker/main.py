import tkinter as tk
from tkinter import ttk, filedialog
import os
import threading

class SeekerApp:
    file_types = {
            "All": "",
            "Text Files (*.txt)": ".txt",
            "PDF Files (*.pdf)": ".pdf",
            "Image Files (*.jpg, *.png, *.gif)": ".jpg.png.gif",
            "Movie Files (*.mp4, *.avi)": ".mp4.avi",
            "Audio Files (*.mp3, *.wav)": ".mp3.wav",
            "Word Files (*.docx)": ".docx",
            "Excel Files (*.xlsx)": ".xlsx",
            "PowerPoint Files (*.pptx)": ".pptx"
        }
    
    def __init__(self, root):
        self.root = root
        self.root.title("Seeker")
        self.root.geometry("600x400")
        
        self.notebook = ttk.Notebook(root)
        self.notebook.pack(fill=tk.BOTH, expand=True)
        
        self.create_search_tab()
        self.create_settings_tab()
        
        self.load_settings()
        
        self.create_status_bar()
        
        self.metadata = {}
        self.searching = False  # Flag to indicate if searching is in progress
    
    def create_search_tab(self):
        search_tab = ttk.Frame(self.notebook)
        self.notebook.add(search_tab, text="Search")
        
        self.create_search_frame(search_tab)
        self.create_result_listbox(search_tab)
    
    def create_search_frame(self, parent):
        self.search_frame = tk.Frame(parent)
        self.search_frame.pack(pady=10)
        
        self.search_label = tk.Label(self.search_frame, text="Search:")
        self.search_label.grid(row=0, column=0)
        
        self.search_entry = tk.Entry(self.search_frame, width=40)
        self.search_entry.grid(row=0, column=1, padx=10)
        
        self.search_button = tk.Button(self.search_frame, text="Search", command=self.start_search)
        self.search_button.grid(row=0, column=2)
    
    def create_result_listbox(self, parent):
        self.result_listbox = tk.Listbox(parent, width=80, height=15)
        self.result_listbox.pack(fill=tk.BOTH, expand=True)
        self.result_listbox.bind("<Double-Button-1>", self.open_item)
    
    def create_settings_tab(self):
        settings_tab = ttk.Frame(self.notebook)
        self.notebook.add(settings_tab, text="Settings")
        
        self.create_settings_frame(settings_tab)
        self.create_save_button(settings_tab)
    
    def create_settings_frame(self, parent):
        self.settings_frame = tk.Frame(parent)
        self.settings_frame.pack(pady=10)
        
        self.path_label = tk.Label(self.settings_frame, text="Select Paths:")
        self.path_label.grid(row=0, column=0)
        
        self.default_path_entry = tk.Entry(self.settings_frame, width=50)
        self.default_path_entry.grid(row=0, column=1, padx=10)
        
        self.default_path_button = tk.Button(self.settings_frame, text="Select", command=self.select_default_path)
        self.default_path_button.grid(row=0, column=2)
        
        self.search_type_label = tk.Label(self.settings_frame, text="Search for:")
        self.search_type_label.grid(row=1, column=0)
        
        self.search_type_var = tk.StringVar()
        self.search_type_var.set("Folder")
        self.search_type_option = tk.OptionMenu(self.settings_frame, self.search_type_var, "Folder", "File Type", command=self.toggle_file_types_dropdown)
        self.search_type_option.grid(row=1, column=1)
        
        self.file_types_label = tk.Label(self.settings_frame, text="File Type:")
        self.file_types_label.grid(row=2, column=0)
        
        self.file_types_var = tk.StringVar()
        self.file_types_option = tk.OptionMenu(self.settings_frame, self.file_types_var, "")
        self.file_types_option.grid(row=2, column=1)
    
    def toggle_file_types_dropdown(self, selected):
        if selected == "File Type":
            self.file_types_option.config(state=tk.NORMAL)
        else:
            self.file_types_option.config(state=tk.DISABLED)
    
    def create_save_button(self, parent):
        self.save_button = tk.Button(parent, text="Save Settings", command=self.save_settings)
        self.save_button.pack(pady=10)
    
    def create_status_bar(self):
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        self.status_bar = tk.Label(self.root, textvariable=self.status_var, bd=1, relief=tk.SUNKEN, anchor=tk.W)
        self.status_bar.pack(side=tk.BOTTOM, fill=tk.X)
    
    def start_search(self):
        if self.searching:
            return
        
        query = self.search_entry.get()
        search_type = self.search_type_var.get()
        path = self.default_path_entry.get()
        
        if not os.path.exists(path):
            self.set_status("Invalid path")
            return
        
        self.result_listbox.delete(0, tk.END)
        self.metadata.clear()
        
        self.searching = True
        
        search_thread = threading.Thread(target=self.search_files, args=(query, search_type, path))
        search_thread.start()
    
    def stop_search(self):
        self.searching = False
    
    def search_files(self, query, search_type, path):
        try:
            if search_type == "Folder":
                num_folders = 0
                for item in os.listdir(path):
                    item_path = os.path.join(path, item)
                    if os.path.isdir(item_path) and query.lower() in item.lower():
                        num_folders += 1
                        display_name = os.path.basename(item_path)
                        self.result_listbox.insert(tk.END, display_name)
                        self.metadata[display_name] = item_path
                        self.update_status_bar(f"Searching ({num_folders} folders found)...")
            elif search_type == "File Type":
                selected_file_type = self.file_types_var.get()
                if selected_file_type:
                    file_type = self.file_types[selected_file_type]
                    num_files = 0
                    for root_dir, _, files in os.walk(path):
                        for file in files:
                            file_path = os.path.join(root_dir, file)
                            if query.lower() in file.lower() and file.lower().endswith(file_type):
                                num_files += 1
                                display_name = os.path.basename(file_path)
                                self.result_listbox.insert(tk.END, display_name)
                                self.metadata[display_name] = file_path
                                self.update_status_bar(f"Searching ({num_files} files found)...")
                    self.update_status_bar(f"Search completed. {num_files} files found.")
                else:
                    self.set_status("Please select a file type")
        except Exception as e:
            self.set_status(f"Error: {str(e)}")
        finally:
            self.stop_search()
    
    def open_item(self, event):
        selected_item_index = self.result_listbox.curselection()
        if selected_item_index:
            selected_display_name = self.result_listbox.get(selected_item_index)
            selected_full_path = self.metadata.get(selected_display_name)
            if selected_full_path:
                if os.path.isdir(selected_full_path):
                    os.startfile(selected_full_path)
                else:
                    os.system("start \"\" \"%s\"" % selected_full_path)
    
    def select_default_path(self):
        path = filedialog.askdirectory()
        if path:
            self.default_path_entry.delete(0, tk.END)
            self.default_path_entry.insert(0, path)
    
    def save_settings(self):
        default_path = self.default_path_entry.get()
        search_type = self.search_type_var.get()
        
        with open("seeker_settings.txt", "w") as f:
            f.write(f"Default Path: {default_path}\n")
            f.write(f"Search Type: {search_type}\n")
            if search_type == "File Type":
                f.write(f"File Type: {self.file_types_var.get()}\n")
        
        self.set_status("Settings saved")
    
    def load_settings(self):
        try:
            with open("seeker_settings.txt", "r") as f:
                settings = f.readlines()
                for line in settings:
                    if line.startswith("Default Path:"):
                        default_path = line.split(": ")[1].strip()
                        self.default_path_entry.insert(0, default_path)
                    elif line.startswith("Search Type:"):
                        search_type = line.split(": ")[1].strip()
                        self.search_type_var.set(search_type)
                        self.update_file_types_dropdown()
                    elif line.startswith("File Type:"):
                        file_type = line.split(": ")[1].strip()
                        self.file_types_var.set(file_type)
        except FileNotFoundError:
            self.set_status("Settings not found")
    
    def update_file_types_dropdown(self):
        menu = self.file_types_option["menu"]
        menu.delete(0, tk.END)
        
        for file_type in SeekerApp.file_types:
            menu.add_command(label=file_type, command=tk._setit(self.file_types_var, file_type))
    
    def set_status(self, status):
        self.status_var.set(status)
    
    def update_status_bar(self, status):
        self.set_status(status)
        if not self.searching:
            self.root.after(2000, self.clear_status_bar)
    
    def clear_status_bar(self):
        if not self.searching:
            self.set_status("Ready")

if __name__ == "__main__":
    root = tk.Tk()
    app = SeekerApp(root)
    root.mainloop()
