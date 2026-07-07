extends Node
## GDScript autoload wrapper for the FileShare Android plugin.
## Add this as an Autoload named "FileShareHelper" in Project Settings,
## or let the EditorPlugin register it automatically.
##
## Usage:
##   FileShareHelper.share("user://myfile.txt")
##   FileShareHelper.file_received.connect(_on_file_received)

const SINGLETON_NAME := "FileShare"

signal file_received(path: String)

var _plugin = null


func _ready() -> void:
	_init_plugin()


func _init_plugin() -> void:
	if Engine.has_singleton(SINGLETON_NAME):
		_plugin = Engine.get_singleton(SINGLETON_NAME)
		_plugin.connect("share_completed", _on_share_completed)
		_plugin.connect("share_error", _on_share_error)
		print("[FileShare] Plugin initialized successfully")
	else:
		printerr("[FileShare] Plugin not available — are you running on Android with the plugin enabled?")


func _process(_delta: float) -> void:
	_check_pending_received_file()


## Polls the native plugin for any file received via Android share intent.
func _check_pending_received_file() -> void:
	if _plugin == null:
		return
	var path: String = _plugin.checkPendingReceivedFile()
	if path != "":
		print("[FileShare] File received at: ", path)
		file_received.emit(path)


## Share a file at the given path.
## Accepts Godot-style paths like "user://myfile.txt".
## The plugin converts them to proper Android paths internally.
func share(path: String) -> void:
	if _plugin == null:
		printerr("[FileShare] Cannot share: plugin not available")
		return
	_plugin.share(path)


## Returns true if the FileShare plugin is available (Android only).
func is_available() -> bool:
	return _plugin != null


func _on_share_completed() -> void:
	print("[FileShare] Share completed")


func _on_share_error(error_message: String) -> void:
	printerr("[FileShare] Share error: ", error_message)
