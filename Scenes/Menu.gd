extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_debug_pressed():
	get_tree().change_scene_to_file("res://Scenes/StageList.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func _on_stagebuilder_pressed():
	get_tree().change_scene_to_file("res://Scenes/StageBuilderProjectList.tscn")
