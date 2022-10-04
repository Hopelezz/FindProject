<div id="top"></div>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">

<h3 align="center">Find File</h3>

  <p align="center">
    A simple file finder app. Built with Powershell.
    <br />
    <br />
<!--     <a href="https://github.com/Hopelezz/FindProject">View Demo</a> 
    ·-->
    <a href="https://github.com/Hopelezz/FindProject/issues">Report Bug</a>
    ·
    <a href="https://github.com/Hopelezz/FindProject/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#setup">Setup</a></li>
      </ul>
    </li>
    <li><a href="#features">Features</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This is a simple Folder Finder app. There are two scripts provided both built-in Powershell. 
- `FindProject.ps1` is a command line editor
- `FindProjectGui.ps1` is a Graphical User Interface.
<br />

![image](https://user-images.githubusercontent.com/72772558/192170170-e65e15b4-c8f7-409c-a167-6257a93a41a5.png)

<p align="right">(<a href="#top">back to top</a>)</p>

### Built With

* [Powershell](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To run the projects you will need to follow the instructions below. This will run a localhost version of the website.

### Installation

1. Clone the repo:
   ```sh
   git clone https://github.com/Hopelezz/FindProject.git
   ```
2. Inside the FindProject folder Right-click on the `FindProject.ps1` file and select `Run with Powershell`.

### Setup

1. Create a Shortcut to the `FindProject.ps1` file.
2. Right-click on the shortcut and select `Properties`.
3. In the `Shortcut` tab, in the `Target` field, add the following at the beginning of the path: `Powershell`. This will prompt Powershell to run the script.


Additionally, you may have to set the execution policy based on your systems administrator settings. Contact your system administrator for more information.

More information on execution policies can be found [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.2).

<p align="right">(<a href="#top">back to top</a>)</p>

### Features

- [x] Create a function that will search for a file in a given directory and 1 subdirectory.
- [x] Create a Graphical User Interface (GUI) for the function.
  - [x] Input field for the file name.
  - [x] Search Button to run the function.
  - [x] ListBox to display the results.

Improvements:
- [x] Pressing `Enter` in the input field should run the function.
- [x] Double-clicking on a result should open the file.
- [x] Add a `Clear` button to clear the input field.
- [x] Add `Warning` if the input is empty or under 3 characters.
- [x] Add `Warning` if the file is not found.
- [x] Add `Try/Catch` to handle errors.
- [x] Add `ContextMenu` to open Path in VS Code
- [x] Add Keybind `Ctrl + Enter` to search C:\ drive.

See the [open issues](https://github.com/Hopelezz/FindProject/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

- [Mark Spratt](https://github.com/Hopelezz)
- [Christopher Strom](https://github.com/ChristopherStrom)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/Hopelezz/FindProject.svg?style=for-the-badge
[contributors-url]: https://github.com/Hopelezz/FindProject/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Hopelezz/FindProject.svg?style=for-the-badge
[forks-url]: https://github.com/Hopelezz/FindProject/network/members
[stars-shield]: https://img.shields.io/github/stars/Hopelezz/FindProject.svg?style=for-the-badge
[stars-url]: https://github.com/Hopelezz/FindProject/stargazers
[issues-shield]: https://img.shields.io/github/issues/Hopelezz/FindProject.svg?style=for-the-badge
[issues-url]: https://github.com/Hopelezz/FindProject/issues
[license-shield]: https://img.shields.io/github/license/Hopelezz/FindProject.svg?style=for-the-badge
[license-url]: https://github.com/Hopelezz/FindProject/blob/master/LICENSE.txt
