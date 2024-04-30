import os
import asyncio
from PyQt5.QtWidgets import (
    QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QLabel, QLineEdit,
    QPushButton, QFileDialog, QComboBox, QListWidget, QTabWidget, QSizePolicy, QSpacerItem, QApplication
)
from qt_material import apply_stylesheet
from Seeker.settings_manager import SettingsManager
from search_manager import SearchManager
from file_manager import FileManager

class SeekerUI(QMainWindow):
    def __init__(self, app):
        super().__init__()
        self.settings_manager = SettingsManager()
        self.app = app
        self.metadata = {}
        self.setup_ui()

    def setup_ui(self):
        self.setWindowTitle("Seeker")
        self.setGeometry(100, 100, 800, 450)
        self.create_titlebar()
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.layout = QVBoxLayout()
        self.central_widget.setLayout(self.layout)
        self.notebook = QTabWidget()
        self.layout.addWidget(self.notebook)
        self.create_search_tab()
        self.create_settings_tab()
        self.load_settings()
        self.set_status("All Systems go!")

    def create_titlebar(self):
        titlebar_layout = QHBoxLayout()
        title_label = QLabel("Seeker")
        title_label.setStyleSheet("font-size: 24px; font-weight: bold;")
        spacer = QSpacerItem(20, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)
        titlebar_layout.addWidget(title_label)
        titlebar_layout.addItem(spacer)

    def create_search_tab(self):
        search_tab = QWidget()
        self.notebook.addTab(search_tab, "Search")

        search_layout = QVBoxLayout()
        search_tab.setLayout(search_layout)

        search_entry_layout = QHBoxLayout()
        search_label = QLabel("Search for:")
        self.search_entry = QLineEdit()
        self.search_button = QPushButton("Search")
        self.search_button.clicked.connect(self.on_search_button_clicked)
        search_entry_layout.addWidget(search_label)
        search_entry_layout.addWidget(self.search_entry)
        search_entry_layout.addWidget(self.search_button)

        search_layout.addLayout(search_entry_layout)

        self.result_listbox = QListWidget()
        self.result_listbox.doubleClicked.connect(self.open_item)  # Connect double-click event directly
        search_layout.addWidget(self.result_listbox)

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
        self.search_type_combo.addItems(self.settings_manager.get_search_types().keys())
        self.search_type_combo.currentIndexChanged.connect(lambda: self.update_file_types_dropdown(self.search_type_combo.currentText()))
        search_type_layout.addWidget(search_type_label)
        search_type_layout.addWidget(self.search_type_combo)

        settings_layout.addLayout(search_type_layout)

        file_type_layout = QHBoxLayout()
        self.file_type_combo = QComboBox()
        self.file_type_combo.setEnabled(False)
        self.file_type_combo.addItems(self.settings_manager.get_file_types().keys())
        file_type_layout.addWidget(QLabel("File Type:"))
        file_type_layout.addWidget(self.file_type_combo)

        settings_layout.addLayout(file_type_layout)

        self.save_button = QPushButton("Save Settings")
        self.save_button.clicked.connect(self.save_settings)
        settings_layout.addWidget(self.save_button)

    def load_settings(self):
        settings = self.settings_manager.load_settings()
        if settings:
            self.theme_combo.setCurrentText(settings["theme"])
            self.default_path_entry.setText(settings["default_path"])
            self.search_type_combo.setCurrentText(settings["search_type"])
            self.update_file_types_dropdown(settings["search_type"])
            self.file_type_combo.setCurrentText(settings["file_type"])

    def save_settings(self):
        settings = {
            "theme": self.theme_combo.currentText(),
            "default_path": self.default_path_entry.text(),
            "search_type": self.search_type_combo.currentText(),
            "file_type": self.file_type_combo.currentText()
        }
        self.settings_manager.save_settings(settings)
        self.set_status("Settings saved")

    def clear_results_listbox(self):
        self.result_listbox.clear()
        self.metadata = {}

    async def start_search(self):
        query = self.search_entry.text().strip()
        search_type = self.search_type_combo.currentText()
        path = self.default_path_entry.text().strip()
        result_listbox = self.result_listbox
        metadata = self.metadata  # Use the metadata provided by the UI instance
        set_feedback = self.set_feedback
        file_type_combo = self.file_type_combo
        settings_manager = self.settings_manager
        
        num_items = 0  # Initialize the number of items found
        
        async def update_status_bar():
            nonlocal num_items
            self.set_status(f"Searching... (Found {num_items} items)")

        try:
            async for item in SearchManager.search_files(query, search_type, path, result_listbox, metadata, set_feedback, file_type_combo, settings_manager):
                num_items += 1
                await update_status_bar()
            
            self.set_status(f"Complete: Found {num_items} items.")
        except Exception as e:
            self.set_status(f"Search failed. Error: {str(e)}")

    def on_search_button_clicked(self):
        self.clear_results_listbox()
        asyncio.run(self.start_search())

    def open_item(self):
            selected_item = self.result_listbox.currentItem()
            if selected_item:
                selected_display_name = selected_item.text()
                selected_full_path = self.metadata.get(selected_display_name)
                if selected_full_path:
                    if os.path.isdir(selected_full_path):
                        FileManager.open_item(selected_full_path)
                    else:
                        self.set_status("Selected item is not a folder.")

    def change_theme(self, index):
        theme = self.theme_combo.itemText(index)
        apply_stylesheet(self.app, theme=theme)
        if "dark" in theme:
            self.setStyleSheet("font-size: 18px; color: white;")
        else:
            self.setStyleSheet("font-size: 18px; color: black;")

    def select_default_path(self):
        path = QFileDialog.getExistingDirectory()
        if path:
            self.default_path_entry.setText(path)

    def update_file_types_dropdown(self, index):
        search_type = self.search_type_combo.currentText()
        self.file_type_combo.clear()
        if search_type == "File Type":
            self.file_type_combo.addItems(SettingsManager.get_file_types().keys())
            self.file_type_combo.setEnabled(True)
        else:
            self.file_type_combo.setEnabled(False)

    def set_status(self, message):
        self.statusBar().showMessage(message)
    
    def set_feedback(self, message):
        self.statusBar().showMessage(message, 5000)
