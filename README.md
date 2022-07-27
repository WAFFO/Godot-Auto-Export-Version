# Godot Auto Export Branch and Commit Number

Please checkout the [original version made by KoBeW](https://github.com/KoBeWi/Godot-Auto-Export-Version) as it has more options to choose from, including Android app versioning.

This is a modification on KoBeW's work to suit my needs for my project. This plugin will create a 'version.gd' file with the variables `BRANCH` and `VERSION`. Where `BRANCH` is the current branch name in your git repository, and `VERSION` is the number of commits, which I treat like a build number.

I find this particularly useful because I like to create release branches such as `release-1.0.0` when I'm ready to share my project. When I create this branch, the plugin will automatically copy the branch name into my game, saving me from having to remember to update some internal variable.

## How to access the branch name and version:

Upon first activation and then after each project export, the plugin will update your `version.gd` file. The plugin contains a constant value called VERSION, which is the current version string. Example usage goes like this:
```GDScript
func _ready():
  var v = load("res://version.gd")
  print("Branch: %s, Version: %d" % [v.BRANCH, v.VERSION])
```
I personally store the branch and version in a Global singleton as I reference it in several locations.

Note: `v.VERSION` is an `int` while `v.BRANCH` is a `String`
