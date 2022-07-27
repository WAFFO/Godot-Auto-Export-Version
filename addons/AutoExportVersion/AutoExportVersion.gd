tool
extends EditorPlugin

# Requires git installed and project inside git repository with at least 1 commit.

## Path to the version script file (bruh).
const VERSION_SCRIPT_PATH = "res://version.gd"

# Returns the number of commits.
func _fetch_version() -> String:
  var output := []
  OS.execute("git", PoolStringArray(["rev-list", "--count", "HEAD"]), true, output)
  if output.empty() or output[0].empty():
    push_error("Failed to fetch version. Make sure you are inside valid git directory.")
    return ""
  else:
    return output[0].trim_suffix("\n")

# Returns the current branch name, such as for feature branches like 'release-1.0.0'
func _fetch_branch() -> String:
  var output := []
  OS.execute("git", PoolStringArray(["rev-parse", "--abbrev-ref", "HEAD"]), true, output)
  if output.empty() or output[0].empty():
    push_error("Failed to fetch version. Make sure you are inside valid git directory.")
    return ""
  else:
    return output[0].trim_suffix("\n")

### Unimportant stuff here.

var exporter: AEVExporter

func _enter_tree() -> void:
  exporter = AEVExporter.new()
  exporter.plugin = self
  add_export_plugin(exporter)
  add_tool_menu_item("Print Current Version", self, "print_version")
  
  if not File.new().file_exists(VERSION_SCRIPT_PATH):
    exporter.store_version(_fetch_version(), _fetch_branch())

func _exit_tree() -> void:
  remove_export_plugin(exporter)
  remove_tool_menu_item("Print Current Version")

func print_version(ud):
  var v = _fetch_version()
  if v.empty():
    OS.alert("Error fetching version. Check console for details.")
  else:
    OS.alert("Current game version: %s" % v)
    print(v)
  var b = _fetch_branch()
  if b.empty():
    OS.alert("Error fetching version. Check console for details.")
  else:
    OS.alert("Current game version: %s" % b)
    print(b)

class AEVExporter extends EditorExportPlugin:
  var plugin
  
  func _export_begin(features: PoolStringArray, is_debug: bool, path: String, flags: int):
    var version: String = plugin._fetch_version(features)
    var branch: String = plugin._fetch_branch(features)
    if version.empty():
      push_error("Version string is empty. Make sure your _fetch_version() is configured properly.")
    
    store_version(version, branch)

  func store_version(version: String, branch: String):
    var script = GDScript.new()
    script.source_code = str("extends Reference\nconst VERSION = ", version, "\nconst BRANCH = \"", branch, "\"\n")
    if ResourceSaver.save(VERSION_SCRIPT_PATH, script) != OK:
      push_error("Failed to save version file. Make sure the path is valid.")
