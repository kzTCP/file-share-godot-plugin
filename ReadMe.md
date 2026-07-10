# FileShare Plugin for Godot 4.X

Android file sharing plugin that allows your Godot app to share files to other apps and receive files from other apps via Android's share intent system.

[![Watch the tutorial on YouTube Shorts](https://img.youtube.com/vi/Z1Y_F_Dj35U/0.jpg)](https://www.youtube.com/shorts/Z1Y_F_Dj35U)

[Download from Godot Asset Store](https://store.godotengine.org/asset/kzcode/file-share-for-anroid/)

## Features

- **Share files** to other Android apps (email, messaging, cloud storage, etc.)
- **Receive files** from other apps via Android share intent
- Simple GDScript API with autoload singleton
- Works with Godot-style paths (`user://`, `res://`, absolute paths)

## Installation

1. Copy the `addons/FileShare` folder to your project's `addons/` directory
2. Enable the plugin in **Project Settings → Plugins** (toggle "Enable" checkbox for FileShare)
3. The plugin will automatically register `FileShareHelper` as an autoload singleton

Alternatively, you can manually add the autoload:
- Go to **Project Settings → Autoload**
- Add `FileShareHelper.gd` with name `FileShareHelper`

## Usage

### Sharing Files

```gdscript
# Share a file from user directory
FileShareHelper.share("user://screenshot.png")

# Share from res directory
FileShareHelper.share("res://exported_data.csv")

# Share from absolute path
FileShareHelper.share("/sdcard/Download/myfile.pdf")
```

### Receiving Files

Connect to the `file_received` signal to handle incoming files:

```gdscript
func _ready():
    if FileShareHelper.is_available():
        FileShareHelper.file_received.connect(_on_file_received)
    else:
        print("FileShare not available - running on non-Android platform?")

func _on_file_received(file_path: String):
    print("File received: ", file_path)
    # Process the received file
    var file = FileAccess.open(file_path, FileAccess.READ)
    if file:
        var content = file.get_as_text()
        file.close()
        # Do something with the content
```

### Checking Availability

Always check if the plugin is available before using it:

```gdscript
if FileShareHelper.is_available():
    FileShareHelper.share("user://mydata.txt")
else:
    print("Cannot share - plugin not available")
```

### Full Example

```gdscript
extends Node

func _ready():
    # Check if plugin is available
    if FileShareHelper.is_available():
        FileShareHelper.file_received.connect(_on_file_received)
        print("FileShare ready!")
    else:
        print("FileShare not available on this platform")

func _on_share_button_pressed():
    # Create a sample file
    save_sample_file("user://shared_data.txt")
    # Share it
    FileShareHelper.share("user://shared_data.txt")

func save_sample_file(path: String):
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_string("This file was shared from my Godot app!")
        file.close()

func _on_file_received(path: String):
    # Show a notification or process the file
    print("Received file: ", path)
    var file = FileAccess.open(path, FileAccess.READ)
    if file:
        var content = file.get_as_text()
        file.close()
        # Update UI or process content
        $Label.text = "Received: " + content
```

## Platform Support

- **Android**: Fully supported
- **iOS**: Not supported (will silently fail)
- **Windows/Linux/macOS**: Not supported (will silently fail)

## Configuration

The plugin automatically configures the Android manifest to:
- Add the `SEND` intent filter
- Set launch mode to `singleTask` to handle multiple instances properly

## Limitations

### Receive Functionality Bug
⚠️ **Known Issue**: The receive functionality has a bug when the app is already running in the background. If you:
1. Have the app open in the background
2. Go to a file manager app
3. Share a file and select your app

The app will crash. This is due to Android's activity lifecycle handling when an intent is received while the app is in the background.

## Signals

### `file_received(path: String)`
Emitted when a file is received via Android share intent.

## Methods

### `share(path: String) -> void`
Share a file at the given path. Supports Godot-style paths (`user://`, `res://`) and absolute paths.

### `is_available() -> bool`
Returns `true` if the plugin is available (i.e., running on Android with the plugin enabled).

## Build Requirements

- Godot 4.X
- Android SDK
- Android Export Template with custom build enabled

## Troubleshooting

### "Plugin not available" Error
- Make sure you're running on an Android device/emulator
- Ensure the plugin is enabled in Project Settings
- Check that the `.aar` files exist in `addons/FileShare/bin/`

### Sharing Doesn't Work
- Verify the file exists at the given path
- Check Android permissions (storage permission may be needed)
- Ensure the file is readable

### App Crashes on Receive
- This is a known bug when receiving files while app is in background
- Save your game/app state frequently
- See the Limitations section for details

## Credits

Developed by kzcode_  

---

## 📦 Download Plugin

You can download the plugin files from the repository or follow the installation instructions above.
[Download from Godot Asset Store](https://store.godotengine.org/asset/kzcode/file-share-for-anroid/)

## License

GPL v3 License - This plugin is free to use, modify, and distribute under the terms of the GNU General Public License version 3.
