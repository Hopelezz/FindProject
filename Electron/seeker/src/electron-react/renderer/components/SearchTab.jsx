import React, { useState } from 'react';
const { ipcRenderer } = window.require('electron');

const SearchTab = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [searchPath, setSearchPath] = useState('');
  const [searchDepth, setSearchDepth] = useState(2);

  const handleSearch = async () => {
    ipcRenderer.send('search-request', searchTerm, searchPath, searchDepth);
  };

  ipcRenderer.on('search-response', (_, results) => {
    setSearchResults(results);
  });

  return (
    <div>
      <input
        type="text"
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        placeholder="Search folders..."
      />
      <button onClick={handleSearch}>Search</button>
      <ul>
        {searchResults.map((result) => (
          <li key={result} onDoubleClick={() => openFolder(result)}>
            {result}
          </li>
        ))}
      </ul>
      {/* Add UI elements for setting searchPath and searchDepth */}
    </div>
  );
};

export default SearchTab;