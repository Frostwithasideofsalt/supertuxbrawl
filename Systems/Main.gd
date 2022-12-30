extends Node

var stage_to_load: String = ""

var stocks = 1

var players = 2
var player_data = [["TestFighter", false], ["TestFighter", true]]

var winner = -1

func load_stage(stage_name: String, is_custom_stage: bool = false):
	stage_to_load = ("user://CustomStages/" if is_custom_stage else "res://Stages/") + stage_name + ".tscn"
	get_tree().change_scene_to_file("res://Systems/MatchManager.tscn")
