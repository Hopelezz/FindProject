import asyncio
import os

class SearchManager:
    @staticmethod
    async def search_files(query, search_type, path, result_listbox, metadata, set_status, file_type_combo, settings_manager):
        try:
            if search_type == "Folder":
                num_folders = 0
                for item in os.listdir(path):
                    item_path = os.path.join(path, item)
                    if os.path.isdir(item_path) and query.lower() in item.lower():
                        num_folders += 1
                        display_name = os.path.basename(item_path)
                        result_listbox.addItem(display_name)
                        metadata[display_name] = item_path
                        await asyncio.sleep(0)  # Yield to update the UI
                set_status(f"Search completed. {num_folders} folders found.")
            elif search_type == "File Type":
                if not file_type_combo or not settings_manager:
                    raise ValueError("File type information not available.")

                selected_file_type = file_type_combo.currentText()
                if selected_file_type:
                    file_types = settings_manager.get_file_types()
                    if selected_file_type == "All Files":
                        num_files = 0
                        for root_dir, _, files in os.walk(path):
                            for file in files:
                                file_path = os.path.join(root_dir, file)
                                if query.lower() in file.lower():
                                    num_files += 1
                                    display_name = os.path.basename(file_path)
                                    result_listbox.addItem(display_name)
                                    metadata[display_name] = file_path
                                    await asyncio.sleep(0)  # Yield to update the UI
                        set_status(f"Search completed. {num_files} files found.")
                    else:
                        file_type = file_types.get(selected_file_type)
                        if file_type:
                            num_files = 0
                            for root_dir, _, files in os.walk(path):
                                for file in files:
                                    file_path = os.path.join(root_dir, file)
                                    if query.lower() in file.lower() and file.lower().endswith(tuple(file_type.split())):
                                        num_files += 1
                                        display_name = os.path.basename(file_path)
                                        result_listbox.addItem(display_name)
                                        metadata[display_name] = file_path
                                        await asyncio.sleep(0)  # Yield to update the UI
                            set_status(f"Search completed. {num_files} files found.")
                        else:
                            raise ValueError("Invalid file type selected.")
                else:
                    raise ValueError("File type not set.")
        except Exception as e:
            set_status(f"Search failed. Error: {str(e)}")


    @staticmethod
    async def start_search(ui_instance, metadata):
        query = ui_instance.search_entry.text().strip()
        search_type = ui_instance.search_type_combo.currentText()
        path = ui_instance.default_path_entry.text().strip()
        result_listbox = ui_instance.result_listbox
        metadata = ui_instance.metadata  # Use the metadata provided by the UI instance
        set_status = ui_instance.set_status
        set_feedback = ui_instance.set_feedback
        file_type_combo = ui_instance.file_type_combo
        settings_manager = ui_instance.settings_manager
        await SearchManager.search_files(query, search_type, path, result_listbox, metadata, set_status, set_feedback, file_type_combo, settings_manager)
