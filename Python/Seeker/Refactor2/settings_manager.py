import json

class SettingsManager:
    SETTINGS_FILE = "seeker_settings.json"

    @staticmethod
    def load_settings():
        try:
            with open(SettingsManager.SETTINGS_FILE, "r") as f:
                return json.load(f)
        except FileNotFoundError:
            return None

    @staticmethod
    def save_settings(settings):
        with open(SettingsManager.SETTINGS_FILE, "w") as f:
            json.dump(settings, f)

    @staticmethod
    def get_file_types():
        return {
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

    @staticmethod
    def get_search_types():
        return {
            "Folder": "Folder",
            "File Type": "File Type"
        }
