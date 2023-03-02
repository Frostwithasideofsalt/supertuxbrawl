extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Main.stages_builtin:
		pass # TODO: list all stages
		var new_item = Button.new()
		new_item.pressed.connect(play_stage.bind(i))
		new_item.text = i
		$GridContainer.add_child(new_item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_stage(stage: String):
	Main.load_stage(stage)
