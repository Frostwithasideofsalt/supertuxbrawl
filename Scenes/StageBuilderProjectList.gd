extends Control


var directory: DirAccess = DirAccess.open("user://CustomStages")

# Called when the node enters the scene tree for the first time.
func _ready():
	if directory:
		directory.list_dir_begin()
		
		while true:
			var stage = directory.get_next()
			
			if stage == "": break
			
			if stage.get_extension() == ".tscn":
				var stage_open_butt: Button = Button.new()
				stage_open_butt.pressed.connect(load_stage_builder.bind(stage))
		
		directory.list_dir_end()

func load_stage_builder(stage: String, is_new: bool = false):
	if !directory:
		var tmp = DirAccess.open("user://")
		tmp.make_dir("CustomStages")
	Main.new_stage = is_new
	Main.stage_to_edit = "user://CustomStages/" + stage
	get_tree().change_scene_to_file("res://Scenes/StageBuilder.tscn")

func _new_button():
	load_stage_builder("new.tscn", true)
