// main.js
const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const searchService = require('./electron-react/main/SearchService.js');

function createWindow () {
  const win = new BrowserWindow({
    width: 800,
    height: 450,
    webPreferences: {
      nodeIntegration: true,
    }
  })

  win.loadFile('index.html')
}

// Handle search requests from the renderer process
ipcMain.on('search-request', async (event, query, dirPath, searchDepth) => {
  const results = await searchService.searchFoldersAsync(query, dirPath, searchDepth);
  event.reply('search-response', results);
});

app.whenReady().then(createWindow)