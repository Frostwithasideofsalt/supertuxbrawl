extends Node2D
class_name MatchManager

@onready var _game_timer = Timer.new()
@onready var stage_camera = Camera2D.new()
var stage: Stage

@onready var kill_check = $KillCheck

var stocks = []
var players_left = 0

func _init(hazards: bool = false):
	pass

func _ready():
	stage = load(Main.stage_to_load).instantiate()
	stage.name = "Stage"
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
	stage_camera.current = true
	place_fighters()
	stage.add_child(stage_camera)
	add_child(_game_timer)
	_game_timer.start()

func place_fighters():
	var fighter_paths = ["res://Fighters/%s.tscn", "res://Fighters/%s.tscn"]
	for i in range(Main.players):
		var fighter: BaseFighter = load(fighter_paths[int(Main.player_data[i][1])] % Main.player_data[i][0]).instantiate()
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
