# AutoAura

[![Launch live demo](https://img.shields.io/badge/Launch-Live_Demo-00C853?style=for-the-badge&logo=githubpages&logoColor=white)](https://sandeepariyar.github.io/AutoAura/)

**Live application:** https://sandeepariyar.github.io/AutoAura/

AutoAura is an interactive automotive dashboard prototype built with **Qt 6**, **C++**, **QML**, and **Qt Design Studio**.

The interface features an animated car visualization, charging controls, seat heating, door controls, climate interaction, and status panels.

## Technology

- Qt Quick and Qt QML for the application interface
- C++ for application startup
- CMake for project configuration
- Qt Shader Tools and Qt Quick Timeline
- Qt Design Studio components and custom graphical effects
- Image sequences for the car animation

## Build for desktop

1. Install Qt 6 with the modules required by `CMakeLists.txt`.
2. Open `CMakeLists.txt` in Qt Creator.
3. Select a compatible desktop Qt kit.
4. Configure and build the `AutoAuraApp` target.

Keep the build directory separate from the source directory. Build outputs, local Qt Creator configuration and temporary files are excluded from version control.

## Browser build

The `.github/workflows/web.yml` workflow builds the Qt application for **WebAssembly** and publishes the output through GitHub Pages after successful compilation.

The browser version uses Qt WebAssembly, not a rewrite of the interface. Some platform-specific functionality may require adaptation.

The application is published at:

[**Open AutoAura in your browser**](https://sandeepariyar.github.io/AutoAura/)

## Project layout

- `App/` — C++ application entry point
- `AutoAura/` — application models and shared QML types
- `AutoAuraContent/` — main interface, controls, fonts and graphics
- `Generated/` — generated shader-effect modules required by the project
- `Dependencies/` — Qt Design Studio component modules
- `qds.cmake` — Qt Design Studio project integration

## Notes

This repository tracks the application source and assets, not Windows executables or CMake caches. Retain applicable copyright notices and licenses for bundled components and resources.
