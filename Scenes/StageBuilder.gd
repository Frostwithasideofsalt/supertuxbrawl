extends Control

var debug_store = Main.debug

func _init():
	if !Main.new_stage:
		$Stage.queue_free()
		var loaded_stage = load(Main.stage_to_edit).instantiate()
		self.add_child(loaded_stage)

func _ready():
	get_tree().paused = false
	Main.debug = true

func _exit_tree():
	get_tree().paused = false
	Main.debug = debug_store

func save_stage():
	var stage: PackedScene = PackedScene.new()
	stage.pack($Stage)
	ResourceSaver.save(stage, Main.stage_to_edit)
