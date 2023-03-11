extends Node2D
class_name MatchManager

@onready var _game_timer = Timer.new()
@onready var stage_camera = Camera2D.new()
var stage: Stage
var stage_uses_hazards: bool

@onready var kill_check = $KillCheck

var stocks = []
var players_left = 0

var target_camera_size: Vector2

func _init(hazards: bool = false):
	Main.connect("debug_changed", change_solids_visibility)
	stage_uses_hazards = hazards

func _ready():
	stage = load(Main.stage_to_load).instantiate()
	stage.name = "Stage"
	stage.use_hazards = stage_uses_hazards
	stage_camera.name = "Stage Camera"
	_game_timer.name = "GameTimer"
	add_child(stage)
	stage_camera.zoom.x = 1.5
	stage_camera.zoom.y = 1.5
	stage_camera.limit_left = -stage.stage_bounds.x / 2
	stage_camera.limit_right = stage.stage_bounds.x / 2
	stage_camera.limit_top = -stage.stage_bounds.y / 2
	stage_camera.limit_bottom = stage.stage_bounds.y / 2
	kill_check.get_node("CollisionShape2d").shape.size = stage.stage_bounds
	place_fighters()
	stage.add_child(stage_camera)
	stage_camera.make_current()
	add_child(_game_timer)
	_game_timer.start()
	target_camera_size = Vector2(ProjectSettings.get("display/window/size/viewport_width"), ProjectSettings.get("display/window/size/viewport_height"))
	get_node("Stage/StageTileMap").set_layer_modulate(0, "#ffffff64" if Main.debug else "#ffffff00")

func _process(_delta):
	return
	var game_viewport = get_viewport_rect()
	if (game_viewport.size.x != target_camera_size.x or game_viewport.size.y != target_camera_size.y):
		var new_zoom = Vector2(1, 1)
		new_zoom.x = game_viewport.size.x / target_camera_size.x
		new_zoom.y = game_viewport.size.y / target_camera_size.y
		stage_camera.zoom = new_zoom
		target_camera_size = game_viewport.size

func place_fighters():
	var fighter_paths = ["res://Fighters/%s.tscn", "user://CustomFighters/%s.tscn"]
	for i in range(Main.players):
		var fighter: BaseFighter = load(fighter_paths[0] % Main.player_data[i][0]).instantiate()
		fighter.is_cpu = Main.player_data[i][1]
		fighter.name = "c" + str(i)
		fighter.position = stage.get_node("PlayerSpawn" + str(i)).position
		fighter.position.y -= float(fighter.HEIGHT) / 2
		fighter.playerid = i
		stage.add_child(fighter)
		stage.get_node("PlayerSpawn" + str(i)).queue_free()
		stocks.append(Main.stocks)
		players_left += 1

func _on_kill_check_body_exited(body):
	if body is BaseFighter:
		body.is_dead = true
		body.position = stage.stage_respawn_point
		stocks[body.playerid] -= 1
		body.get_node("Hitbox").set_deferred("monitorable", false)
		if stocks[body.playerid] > 0: body.respawn_timer.start(4)
		else:
			players_left -= 1
			if players_left == 1:
				for stock in range(len(stocks)):
					if stocks[stock] != 0:
						Main.winner = stock
						break
				get_tree().change_scene_to_file("res://Scenes/ResultsStage.tscn")

func _exit_tree():
	Main.disconnect("debug_changed", change_solids_visibility)

func change_solids_visibility(debug: bool):
	var new_modulate = Color.from_string("#ffffff64", Color.RED)
	if not debug:
		new_modulate = Color.from_string("#ffffff00", Color.TRANSPARENT)
	var tilemap: TileMap = get_node("Stage/StageTileMap")
	tilemap.set_layer_modulate(0, new_modulate)
