extends Node2D
class_name MatchManager

@onready var _game_timer = Timer.new()
@onready var stage_camera = Camera2D.new()
var stage: Stage

func _ready():
	stage = load(Main.stage_to_load).instantiate()
	stage.name = "Stage"
	stage_camera.name = "Stage Camera"
	_game_timer.name = "GameTimer"
	add_child(stage)
	stage_camera.zoom.x = 2.0
	stage_camera.zoom.y = 2.0
	stage_camera.limit_left = -stage.stage_bounds.x / 2
	stage_camera.limit_right = stage.stage_bounds.x / 2
	stage_camera.limit_top = -stage.stage_bounds.y / 2
	stage_camera.limit_bottom = stage.stage_bounds.y / 2
	stage_camera.current = true
	place_fighters()
	stage.add_child(stage_camera)
	add_child(_game_timer)
	_game_timer.start()

func place_fighters():
	var fighter_paths = ["res://Fighters/%s.tscn", "res://Fighters/%s.tscn"]
	for i in range(Main.players):
		var fighter: BaseFighter = load(fighter_paths[int(Main.player_data[i][1])] % Main.player_data[i][0]).instantiate()
		fighter.name = "c" + str(i)
		fighter.position = stage.get_node("PlayerSpawn" + str(i)).position
		fighter.position.y -= fighter.HEIGHT / 2
		stage.add_child(fighter)
		stage.get_node("PlayerSpawn0").queue_free()
