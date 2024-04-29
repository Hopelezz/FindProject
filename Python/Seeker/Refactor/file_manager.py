import os

class FileManager:
    @staticmethod
    def open_item(item_path):
        if os.path.isdir(item_path):
            os.startfile(item_path)
        else:
            os.system("start \"\" \"%s\"" % item_path)
