# Terminal Wallpaper KDE

![Demo](https://github.com/cycloarcane/terminal-wallpaper-kde/raw/main/assets/cmatrix.gif)

A simple way to use **KDE Window Rules** and the **Kitty terminal** to display dynamic terminal output as your **wallpaper** in KDE Plasma.

## Features
- Uses **KDE Window Rules** to keep a transparent terminal as the wallpaper.
- Supports multiple monitors with customizable terminal output per screen.
- Automatically starts on login (via `.xprofile` on X11, KDE Autostart for Wayland users).
- Works with any terminal-friendly application (e.g., `cmatrix`, `neofetch`, `htop`).

## Installation

### 1. Set Up KDE Window Rules

To keep the terminal as the wallpaper, configure **KDE Window Rules**.

- Open **System Settings** > **Window Management** > **Window Rules**.
- Create a new rule for your terminal.
- Use the settings in the provided example:

  ![KDE Window Rules Example](https://github.com/cycloarcane/terminal-wallpaper-kde/raw/main/assets/wallpaper_edp_rules.png)

- Ensure the terminal is set to be **borderless, below other windows, and non-interactive**.

### 2. Configure the Startup Script

Modify the provided script to match your display configuration. By default, it contains entries for two monitors: `eDP` and `HDMI`.

If you have more monitors, duplicate the necessary entries and update the **KDE Window Rules** accordingly.

### 3. Autostart on Login

#### **For X11 Users**
Edit your `~/.xprofile` file and add the following line:

```bash
~/path/to/start_script.sh &
```

#### **For Wayland Users**
Use KDE's built-in **Autostart**:

- Open **System Settings** > **Startup and Shutdown** > **Autostart**.
- Add the `start_script.sh` file to **start automatically at login**.

## Customization

- Change the terminal output (e.g., use `cmatrix`, `btop`, `neofetch`).
- Modify the transparency settings in your terminal emulator for better visibility.
- Adjust the KDE Window Rules to fine-tune the appearance.
- Check out the funcommands file for a few examples

## Troubleshooting

- **Terminal not appearing as wallpaper?** Double-check the KDE Window Rules and ensure it matches the correct window class.
- **Not starting at login?** Verify `.xprofile` (X11) or KDE Autostart (Wayland) settings.
- **Want different outputs per monitor?** Duplicate the script entries and window rules for each display.

## Contributing
Feel free to **fork, modify, and submit pull requests** to improve this project!

## License
[MIT License](LICENSE)

