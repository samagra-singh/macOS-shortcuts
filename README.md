# macOS Shortcuts

A collection of macOS Shortcuts that make life a little easier, one keyboard shortcut at a time. Because clicking is so 2020.

## What's Inside

5 handy keyboard shortcuts that run scripts, turning complex workflows into simple key combinations.

### 🎤 Mute/Unmute Microphone (`Opt+Ctrl+M`)

Toggle your mic on and off with a single shortcut. It even remembers your previous volume level—because who wants to shout after unmuting at 100%?

### 🎧 Switch Audio Output (`Cmd+Opt+Ctrl+D`)

Cycle through your audio devices without diving into System Settings or finding the menu bar. Perfect for switching between speakers, monitors, and headphones. The script remembers your rotation order, so you can hop between devices like a digital DJ.

**Note:** HomePod-like AirPlay devices that only appear when viewing sound settings are not supported.

### 📋 Copy File Content (`Opt+Ctrl+Shift+C`)

Quickly copy text content to the clipboard from Finder without opening it.

Select a file in Finder and copy its entire contents to your clipboard. No more opening files just to copy text. It's smart enough to skip binary files (because nobody wants PDF bytes in their clipboard), folders, and empty files.

### 📝 Paste Clipboard as File (`Opt+Ctrl+Shift+V`)

Quickly paste from the clipboard to Finder without opening a text editor.

The opposite of the above — paste your clipboard text as a new file in the current Finder location. Great for quick note-taking or saving snippets.

### 💾 Paste to Shared Folder (`Opt+Ctrl+V`)

Quickly save clipboard text to `/Users/Shared` with a timestamp. Handy for cross-user workflows or when you need a quick dump location.

Useful for sharing the clipboard in multi-user systems.

## Prerequisites

- **macOS** (obviously)
- **Homebrew** (for installing dependencies)
- **SwitchAudioSource** (for the audio switching script):
 ```bash
  brew install switchaudio-osx
 ```

That's it. The rest uses built-in macOS tools like `osascript`, `pbcopy`, and `pbpaste`.

## Setup

### Option 1: Use Pre-built Shortcuts (Easiest, Highly Recommended)

1. Open the `dist/Keyboard Utils/` folder
2. Download and double-click any `.shortcut` file to import it into the Shortcuts app
3. Assign your preferred keyboard shortcut by:
  1. Open shortcut. Click "i" in the side pane. Click "Add Keyboard Shortcut" and choose the recommended keyboard shortcut or something you prefer. (The recommended ones are unlikely to clash with other shortcuts from Chrome, VS Code, etc.)
  2. System Settings → Keyboard → Keyboard Shortcuts → App Shortcuts
4. Modify the "Allow When Screen Is Locked" setting in the "Privacy" tab of the shortcut as needed.
5. Run the shortcut once to get the necessary triggers for permissions. (Tip: Grant full disk access to use the Finder keyboard shortcuts seamlessly.)

### Option 2: Use the Scripts and create shortcuts from scratch

You can use the `.sh` scripts directly with your preferred shortcut manager and create a shortcut as per your needs.

## Configuration

### Audio Output Switching

Edit the `AUDIO_OUTPUTS` array in the script to match your devices:

```bash
AUDIO_OUTPUTS=(
    "MacBook Pro Speakers"
    "Your Monitor Name"
    "Your Headphones"
)
```

To discover your exact device names, run:
```bash
SwitchAudioSource -a -t output
```

Copy the exact names (they're case-sensitive) into the array. The script cycles through them in order. If an unknown device is currently selected, the script will select the 1st item (this should ideally be your Mac itself).

### File Paths

Most scripts work out of the box, but you can customise:
- **Paste to Shared**: Change `DEST_DIR` in `Opt+Ctrl+V -- Paste Clipboard (text) To Shared.sh`
- **SwitchAudioSource path**: Update `SWITCHER` path if you installed it elsewhere.
  - Run `which SwitchAudioSource` to get the path.

## How It Works

These scripts are simple bash scripts that leverage macOS's built-in tools:
- **AppleScript** (`osascript`) for Finder integration and notifications
- **pbpaste/pbcopy** for clipboard operations
- **SwitchAudioSource** for audio device management

They're designed to be fast, reliable, and non-intrusive. Each script does one thing well.

## Troubleshooting

**"Command not found" errors:**
- Make sure scripts are executable (`chmod +x`)
- Verify `SwitchAudioSource` is installed and the script has the right path.
  - Run `which SwitchAudioSource` to get/verify the path.

**Permission issues**
- Ensure you're using **bash shell** (not zsh or other shells). This should be a dropdown in the shortcut app. You can also check by adding `echo $SHELL` to the terminal/script.
- Saving scripts in a directory and running those using this path (e.g., `/path/to/script.sh`) can sometimes cause permission issues.
  - For simplicity, paste the script content directly into your shortcut manager.

**Audio switching not working:**
- Check that device names in the array match exactly (run `SwitchAudioSource -a -t output` to verify)
- Ensure the Shortcuts.app or the script has accessibility permissions (System Settings → Privacy & Security)

**Copy/Paste issues with Finder**
- Ensure your shortcut app or the script has full disk access or access to specific folders where you want to use these features:
  1. Go to **System Settings → Privacy & Security → Full Disk Access**
  2. Click the **+** button and add:
     - **Shortcuts.app** (if using pre-built shortcuts), or
     - **Terminal.app** / **iTerm.app** (if running scripts directly), or
     - Your shortcut manager (Raycast, Alfred, etc.)
  3. Alternatively, for folder-specific access:
     - Go to **System Settings → Privacy & Security → Files and Folders**
     - Grant access to specific folders where you want to copy/paste files
  4. Restart the Shortcuts app or your terminal/shortcut manager after granting permissions

**Emojis showing as question marks:**
- This is a limitation we're unable to bypass at the moment. We attempt to preserve emojis while copying/pasting, but they may become corrupted during the process.

**Shortcuts not triggering:**
- Check for conflicts in System Settings → Keyboard → Keyboard Shortcuts
- Ensure your shortcut manager has the necessary permissions.

## License

Use these scripts however you want. They're here to make your life easier, not to complicate it with legal jargon.

## Contributors

Contributions welcome! If you have ideas for new shortcuts or improvements, feel free to open an issue or submit a pull request.

### TODOs

[ ] Identify which scripts run in bash and zsh, and which ones only in bash. Tag them in the `README`, and support both if possible.
[ ] Fix emoji issue in copy/paste scripts.
[ ] Identify which scripts require which permissions and clarify in `README`.

---

*Made with ⌨️ and ☕ for macOS users who value efficiency over clicking.*
