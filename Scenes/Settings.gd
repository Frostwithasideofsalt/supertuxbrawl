extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"TabContainer/Code License".text = "[center]" + Main.license["content"] + "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
