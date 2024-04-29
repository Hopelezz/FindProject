import sys
import os
import threading
import json
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QLabel, QLineEdit, QPushButton, QFileDialog, QComboBox, QListWidget,
    QMessageBox, QTabWidget, QSizePolicy, QSpacerItem
)
from qt_material import apply_stylesheet

class SeekerApp(QMainWindow):
    file_types = {
        "All Files": ".",
        "Text Files": ".txt",
        "PDF Files": ".pdf",
        "Image Files": ".jpg .jpeg .png .gif .bmp .tiff",
        "Movie Files": ".mp4 .avi .mkv .mov .wmv .flv .mpeg",
        "Audio Files": ".mp3 .wav .ogg .aac .flac .wma",
        "Word Files": ".doc .docx",
        "Excel Files": ".xls .xlsx .csv",
        "PowerPoint Files": ".ppt .pptx",
        "Archive Files": ".zip .rar .tar .7z .gz",
        "Executable Files": ".exe .msi .dmg .app",
        "Code Files": ".py .java .cpp .c .html .css .js .php .rb .pl .sql",
        "Markdown Files": ".md .markdown",
        "Font Files": ".ttf .otf .woff .woff2",
        "Video Subtitle Files": ".srt .sub .sbv .ass",
        "Vector Image Files": ".svg .ai .eps .pdf",
        "CAD Files": ".dwg .dxf .stl .obj .step .iges",
        "GIS Files": ".shp .kml .kmz .gpx .geojson",
        "Database Files": ".sqlite .db .sql",
        "Backup Files": ".bak .backup",
        "Torrent Files": ".torrent",
        "Log Files": ".log"
    }
    search_types = {
        "Folder": "Folder",
        "File Type": "File Type"
    }

    def __init__(self):
        super().__init__()

        self.setWindowTitle("Seeker")
        self.setGeometry(100, 100, 600, 400)
        self.feedback_label = QLabel()
        self.feedback_label.setStyleSheet("color: red;")

        self.status_bar = QLabel("Ready")

        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)

        self.layout = QVBoxLayout()
        self.central_widget.setLayout(self.layout)

        self.notebook = QTabWidget()
        self.layout.addWidget(self.notebook)

        self.create_search_tab()
        self.create_settings_tab()

        self.load_settings()

        self.layout.addWidget(self.status_bar)
        self.layout.addWidget(self.feedback_label)

        self.searching = False
        self.metadata = {}  # Initialize metadata attribute

    def create_search_tab(self):
        search_tab = QWidget()
        self.notebook.addTab(search_tab, "Search")

        search_layout = QVBoxLayout()
        search_tab.setLayout(search_layout)


        search_entry_layout = QHBoxLayout()
        search_label = QLabel("Search for:")
        self.search_entry = QLineEdit()
        self.search_button = QPushButton("Search")
        self.search_button.clicked.connect(self.start_search)
        search_entry_layout.addWidget(self.search_entry)
        search_entry_layout.addWidget(self.search_button)

        search_layout.addWidget(search_label)
        search_layout.addLayout(search_entry_layout)

        self.result_listbox = QListWidget()
        search_layout.addWidget(self.result_listbox)
        self.result_listbox.doubleClicked.connect(self.open_item)
        
    def create_settings_tab(self):
        settings_tab = QWidget()
        self.notebook.addTab(settings_tab, "Settings")

        settings_layout = QVBoxLayout()
        settings_tab.setLayout(settings_layout)

        select_theme_layout = QHBoxLayout()
        select_theme_label = QLabel("Select Theme:")
        self.theme_combo = QComboBox()
        self.theme_combo.addItems(["dark_amber.xml", "dark_blue.xml", "dark_cyan.xml", "dark_lightgreen.xml",
                                    "dark_pink.xml", "dark_purple.xml", "dark_red.xml", "dark_teal.xml",
                                    "dark_yellow.xml", "light_amber.xml", "light_blue.xml", "light_cyan.xml",
                                    "light_cyan_500.xml", "light_lightgreen.xml", "light_pink.xml", "light_purple.xml",
                                    "light_red.xml", "light_teal.xml", "light_yellow.xml"])
        self.theme_combo.currentIndexChanged.connect(self.change_theme)
        select_theme_layout.addWidget(select_theme_label)
        select_theme_layout.addWidget(self.theme_combo)

        settings_layout.addLayout(select_theme_layout)

        select_paths_layout = QHBoxLayout()
        select_paths_label = QLabel("Default Paths:")
        self.default_path_entry = QLineEdit()
        select_paths_button = QPushButton("Select")
        select_paths_button.clicked.connect(self.select_default_path)
        select_paths_layout.addWidget(select_paths_label)
        select_paths_layout.addWidget(self.default_path_entry)
        select_paths_layout.addWidget(select_paths_button)

        settings_layout.addLayout(select_paths_layout)

        search_type_layout = QHBoxLayout()
        search_type_label = QLabel("Search for:")
        self.search_type_combo = QComboBox()
        self.search_type_combo.addItems(self.search_types.keys())
        self.search_type_combo.currentIndexChanged.connect(lambda: self.update_file_types_dropdown(self.search_type_combo.currentText()))
        search_type_layout.addWidget(search_type_label)
        search_type_layout.addWidget(self.search_type_combo)

        settings_layout.addLayout(search_type_layout)

        file_type_layout = QHBoxLayout()
        self.file_type_combo = QComboBox()
        self.file_type_combo.setEnabled(False)
        self.file_type_combo.addItems(self.file_types.keys())
        file_type_layout.addWidget(QLabel("File Type:"))
        file_type_layout.addWidget(self.file_type_combo)

        settings_layout.addLayout(file_type_layout)

        self.save_button = QPushButton("Save Settings")
        self.save_button.clicked.connect(self.save_settings)
        settings_layout.addWidget(self.save_button)

    def change_theme(self, index):
        theme = self.theme_combo.itemText(index)
        self.load_stylesheet(theme)
    
    def load_stylesheet(self, theme):
        apply_stylesheet(app, theme=theme)
        if "dark" in theme:
            self.setStyleSheet("font-size: 16px; color: white;")
        else:
            self.setStyleSheet("font-size: 16px; color: black;")

    def start_search(self):
        if self.searching:
            return

        query = self.search_entry.text().strip()  # Get the search query and remove leading/trailing whitespace

        if not query:  # Check if the search query is empty
            self.set_feedback("Please enter a search query.")
            return

        search_type = self.search_type_combo.currentText()
        path = self.default_path_entry.text()

        if not os.path.exists(path):
            self.set_feedback("Invalid path")
            return

        self.result_listbox.clear()
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
                        self.result_listbox.addItem(display_name)
                        self.metadata[display_name] = item_path
                        self.set_status(f"Searching ({num_folders} folders found)...")
            elif search_type == "File Type":
                selected_file_type = self.file_type_combo.currentText()
                if selected_file_type:
                    if selected_file_type == "All Files":  # Handle the case when "All Files" is selected
                        num_files = 0
                        for root_dir, _, files in os.walk(path):
                            for file in files:
                                file_path = os.path.join(root_dir, file)
                                # Add all files without filtering based on file type
                                if query.lower() in file.lower():
                                    num_files += 1
                                    display_name = os.path.basename(file_path)
                                    self.result_listbox.addItem(display_name)
                                    self.metadata[display_name] = file_path
                                    self.set_status(f"Searching ({num_files} files found)...")
                        self.set_status(f"Search completed. {num_files} files found.")
                    else:
                        file_type = self.file_types[selected_file_type]
                        num_files = 0
                        for root_dir, _, files in os.walk(path):
                            for file in files:
                                file_path = os.path.join(root_dir, file)
                                # Check if the file has the specified extension
                                if query.lower() in file.lower() and file.lower().endswith(tuple(file_type.split())):
                                    num_files += 1
                                    display_name = os.path.basename(file_path)
                                    self.result_listbox.addItem(display_name)
                                    self.metadata[display_name] = file_path
                                    self.set_status(f"Searching ({num_files} files found)...")
                        self.set_status(f"Search completed. {num_files} files found.")
                else:
                    self.set_feedback("File type not set.")
        except Exception as e:
            self.set_feedback(f"Error: {str(e)}")
        finally:
            self.stop_search()


    def open_item(self, event):
        selected_item_index = self.result_listbox.currentRow()
        if selected_item_index >= 0:
            selected_display_name = self.result_listbox.item(selected_item_index).text()
            selected_full_path = self.metadata.get(selected_display_name)
            if selected_full_path:
                if os.path.isdir(selected_full_path):
                    self.set_status(f"Opening Folder: {selected_full_path}")
                    os.startfile(selected_full_path)
                else:
                    self.set_status(f"Opening File: {selected_full_path}")
                    os.system("start \"\" \"%s\"" % selected_full_path)

    def select_default_path(self):
        path = QFileDialog.getExistingDirectory()
        if path:
            self.default_path_entry.setText(path)

    def save_settings(self):
        settings = {
            "theme": self.theme_combo.currentText(),
            "default_path": self.default_path_entry.text(),
            "search_type": self.search_type_combo.currentText(),
            "file_type": self.file_type_combo.currentText()
        }
        with open("seeker_settings.json", "w") as f:
            json.dump(settings, f)
        self.set_status("Settings saved")

    def load_settings(self):
        try:
            with open("seeker_settings.json", "r") as f:
                settings = json.load(f)
                # Load theme settings
                theme = settings.get("theme", "dark_blue.xml")  # Use a default value if "theme" key does not exist
                self.theme_combo.setCurrentText(theme)
                self.change_theme(self.theme_combo.currentIndex())
                default_path = settings.get("default_path", "")
                if isinstance(default_path, int):
                    default_path = str(default_path)
                self.default_path_entry.setText(default_path)
                self.search_type_combo.setCurrentText(settings["search_type"])
                self.update_file_types_dropdown(settings["search_type"])
                if settings["search_type"] == "File Type":
                    self.file_type_combo.setCurrentText(settings["file_type"])
        except FileNotFoundError:
            self.set_status("Settings not found")

    def update_file_types_dropdown(self, selected):
        self.file_type_combo.clear()

        if selected == "Folder":
            self.file_type_combo.setEnabled(False)
            self.file_type_combo.clear()
        elif selected == "File Type":
            self.file_type_combo.setEnabled(True)
            self.file_type_combo.addItems([key.strip() for key in self.file_types.keys()])
        else:
            self.file_type_combo.setEnabled(False)
            self.set_feedback("Invalid search type")


    def set_status(self, status):
        self.status_bar.setText(status)

    def set_feedback(self, warning):
        self.feedback_label.setText(warning)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = SeekerApp()
    window.show()
    sys.exit(app.exec_())
