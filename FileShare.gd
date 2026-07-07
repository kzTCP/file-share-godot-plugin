@tool
extends EditorPlugin

const PLUGIN_AUTOLOAD_NAME = "FileShareHelper"

var _export_plugin: AndroidExportPlugin


func _enter_tree() -> void:
	_export_plugin = AndroidExportPlugin.new()
	add_export_plugin(_export_plugin)
	# Add the GDScript wrapper as an autoload
	add_autoload_singleton(PLUGIN_AUTOLOAD_NAME, "res://addons/FileShare/FileShareHelper.gd")


func _exit_tree() -> void:
	remove_export_plugin(_export_plugin)
	remove_autoload_singleton(PLUGIN_AUTOLOAD_NAME)
	_export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:

	var _plugin_name = "FileShare"

	func _supports_platform(platform: EditorExportPlatform) -> bool:
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		if debug:
			return PackedStringArray(["res://addons/FileShare/bin/FileShare-debug.aar"])
		else:
			return PackedStringArray(["res://addons/FileShare/bin/FileShare-release.aar"])

	func _get_name() -> String:
		return _plugin_name

	func _get_android_manifest_activity_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		return """
			<intent-filter>
				<action android:name="android.intent.action.SEND" />
				<category android:name="android.intent.category.DEFAULT" />
				<data android:mimeType="*/*" />
			</intent-filter>
		"""

	# ADD THIS - Sets the launch mode to prevent multiple instances
	func _get_android_manifest_activity_element_attributes(platform: EditorExportPlatform, debug: bool) -> String:
		return 'android:launchMode="singleTask"'
