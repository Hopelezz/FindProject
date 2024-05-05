import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLabel, QVBoxLayout, QPushButton, QLineEdit, QMessageBox, QDialog, QMainWindow, QStatusBar, QHBoxLayout
from PyQt5.QtGui import QFont, QIcon
from PyQt5.QtCore import Qt
import sqlite3
import hashlib

class LoginWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Chartium - Login')
        self.setWindowIcon(QIcon('chartium_icon.png'))
        self.setGeometry(100, 100, 400, 300)

        self.init_ui()

    def init_ui(self):
        # Create labels
        label_title = QLabel('Welcome to Chartium', self)
        label_title.setFont(QFont('Arial', 20, QFont.Bold))

        # Create line edits for username and password with placeholders
        self.username_edit = QLineEdit(self)
        self.username_edit.setPlaceholderText('Username')
        self.password_edit = QLineEdit(self)
        self.password_edit.setPlaceholderText('Password')
        self.password_edit.setEchoMode(QLineEdit.Password)

        # Create login and sign-up buttons
        login_button = QPushButton('Login', self)
        login_button.clicked.connect(self.login)

        signup_button = QPushButton('Sign Up', self)
        signup_button.clicked.connect(self.signup)

        # Create horizontal layout for buttons
        buttons_layout = QHBoxLayout()
        buttons_layout.addWidget(login_button)
        buttons_layout.addWidget(signup_button)

        # Apply flat modern style to widgets
        self.setStyleSheet('''
            QLabel {
                color: #444;
                font-size: 16px;
            }
            QLineEdit, QPushButton {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background-color: #f9f9f9;
                font-size: 16px;
            }
            QPushButton:hover {
                background-color: #ddd;
            }
            QPushButton:pressed {
                background-color: #bbb;
            }
        ''')

        # Create layout
        layout = QVBoxLayout()
        layout.addWidget(label_title)
        layout.addWidget(self.username_edit)
        layout.addWidget(self.password_edit)
        layout.addLayout(buttons_layout)  # Add the buttons layout
        layout.setAlignment(label_title, Qt.AlignCenter)

        self.setLayout(layout)

        # Connect to the SQLite database
        self.conn = sqlite3.connect('chartium.db')
        self.cur = self.conn.cursor()



        # Create the users table if it doesn't exist
        self.cur.execute('''CREATE TABLE IF NOT EXISTS users (
                            id INTEGER PRIMARY KEY,
                            username TEXT UNIQUE,
                            password TEXT)''')
        self.conn.commit()

        # Flag to keep track of login status
        self.logged_in = False

    def login(self):
        username = self.username_edit.text()
        password = self.password_edit.text()

        # Retrieve hashed password from the database based on the entered username
        self.cur.execute("SELECT password FROM users WHERE username=?", (username,))
        result = self.cur.fetchone()

        if result:
            stored_password = result[0]
            # Hash the entered password using SHA-256
            hashed_password = hashlib.sha256(password.encode()).hexdigest()

            if hashed_password == stored_password:
                # Open the main window/dashboard after successful login
                self.main_window = MainWindow(username)
                self.main_window.show()
                self.logged_in = True
                self.hide()
            else:
                QMessageBox.warning(self, 'Login Failed', 'Invalid username or password')
        else:
            QMessageBox.warning(self, 'Login Failed', 'Invalid username or password')

    def signup(self):
        signup_dialog = SignUpDialog(self)
        if signup_dialog.exec_() == QDialog.Accepted:
            # Update status bar of the loginwindow
            self.statusBar().showMessage('Sign up successful. You can now login.')

    def closeEvent(self, event):
        # Override closeEvent to check if user is logged in before closing
        if self.logged_in:
            event.ignore()
        else:
            event.accept()

class SignUpDialog(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle('Chartium - Sign Up')
        self.setWindowModality(Qt.WindowModal)

        self.init_ui()

    def init_ui(self):
        # Create labels
        label_title = QLabel('Sign Up for Chartium', self)
        label_title.setFont(QFont('Arial', 20, QFont.Bold))

        label_username = QLabel('Username:', self)
        label_password = QLabel('Password:', self)

        # Create line edits for username and password
        self.username_edit = QLineEdit(self)
        self.password_edit = QLineEdit(self)
        self.password_edit.setEchoMode(QLineEdit.Password)

        # Create sign-up button
        signup_button = QPushButton('Sign Up', self)
        signup_button.clicked.connect(self.create_account)

        # Apply flat modern style to widgets
        self.setStyleSheet('''
            QLabel {
                color: #444;
                font-size: 16px;
            }
            QLineEdit, QPushButton {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background-color: #f9f9f9;
                font-size: 16px;
            }
            QPushButton:hover {
                background-color: #ddd;
            }
            QPushButton:pressed {
                background-color: #bbb;
            }
        ''')

        # Create layout
        layout = QVBoxLayout()
        layout.addWidget(label_title)
        layout.addWidget(label_username)
        layout.addWidget(self.username_edit)
        layout.addWidget(label_password)
        layout.addWidget(self.password_edit)
        layout.addWidget(signup_button)
        layout.setAlignment(label_title, Qt.AlignCenter)
        layout.setAlignment(signup_button, Qt.AlignCenter)

        self.setLayout(layout)

    def create_account(self):
        username = self.username_edit.text()
        password = self.password_edit.text()

        # Check if the username already exists in the database
        self.parent().cur.execute("SELECT * FROM users WHERE username=?", (username,))
        result = self.parent().cur.fetchone()

        if result:
            QMessageBox.warning(self, 'Sign Up Failed', 'Username already exists. Please choose another username.')
        else:
            # Hash the password using SHA-256
            hashed_password = hashlib.sha256(password.encode()).hexdigest()
            # Insert the new user into the database
            self.parent().cur.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, hashed_password))
            self.parent().conn.commit()
            self.accept()  # Close the dialog upon successful sign-up

class MainWindow(QMainWindow):
    def __init__(self, username):
        super().__init__()
        self.setWindowTitle('Chartium - Dashboard')
        self.setGeometry(100, 100, 800, 600)

        # Add a status bar
        self.statusBar().showMessage(f'Welcome, {username}!')

        # Add your main window/dashboard layout and functionality here

if __name__ == '__main__':
    app = QApplication(sys.argv)
    login_window = LoginWindow()
    login_window.show()
    sys.exit(app.exec_())
