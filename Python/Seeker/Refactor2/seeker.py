# seeker.py
import sys
from PyQt5.QtWidgets import QApplication
from seeker_ui import SeekerUI

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = SeekerUI(app)
    window.show()
    sys.exit(app.exec_())

