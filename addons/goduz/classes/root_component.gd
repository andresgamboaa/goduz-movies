extends BaseRootComponent
class_name RootComponent
# Author: Andres Gamboa

func _init():
	super()
	presets_path = "res://presets.tscn"

func view():
	return\
	Gui.control({preset="full"}, [
		Movies.new()
	])
