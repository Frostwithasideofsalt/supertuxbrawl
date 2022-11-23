extends Control


# CBA to add yet
func _ready():
	print("NO INTRO, CHANGING SCENE TO: res://Scenes/Menu.tscn")
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
