extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var text: Label = get_node("Label")
	text.text = text.text % [Main.player_data[Main.winner][0], Main.winner + 1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
