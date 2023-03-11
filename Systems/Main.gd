extends Node

var license: Dictionary = {
	"name" : "GNU GPLv3",
	"content" : ""
}

var stages_builtin: Array = []
var stages_community: Array = []
var stage_to_load: String = ""

var stage_to_edit: String = ""
var new_stage: bool = false

var stocks = 1

var players = 2
var player_data = [["TestFighter", false], ["TestFighter", true]]

var winner = -1

## Determines if solids should be visible
var debug = OS.is_debug_build()

signal debug_changed(value: bool)

func _init():
	var read = FileAccess.open("res://LICENSE", FileAccess.READ)
	license["content"] = read.get_as_text()
	read.close()
	
	var directory = DirAccess.open("res://Stages")
	directory.list_dir_begin()
	while true:
		var current = directory.get_next()
		if current == "": break
		
		if current.ends_with(".tscn"):
			stages_builtin.append(current.get_basename())
	directory.list_dir_end()
	
	get_community_stage_list()
	
	print("SuperTuxBrawl is provided under the GNU General Public License version 3 or above.
For more information, go to Settings > License in game, see the license file that came with your distribution of SuperTuxBrawl or see the online version at https://github.com/tulip-sudo/supertuxbrawl/blob/main/LICENSE\n")

func get_community_stage_list():
	stages_community.clear()
	var directory = DirAccess.open("user://CustomStages")
	
	if !directory:
		var tmp = DirAccess.open("user://")
		tmp.make_dir("CustomStages")
		directory = DirAccess.open("user://CustomStages")
	
	directory.list_dir_begin()
	while true:
		var current = directory.get_next()
		if current == "": break
		
		if current.ends_with(".tscn"):
			current = current.substr(0, current.find(".tscn"))
			stages_community.append("user://CustomStages/" + current)
	directory.list_dir_end()

func _process(_delta):
	if Input.is_action_just_pressed("debug_toggle"):
		print("Toggling debug")
		toggle_debug()

func load_stage(stage_name: String, is_custom_stage: bool = false):
	stage_to_load = ("user://CustomStages/" if is_custom_stage else "res://Stages/") + stage_name + ".tscn"
	get_tree().change_scene_to_file("res://Systems/MatchManager.tscn")

func toggle_debug():
	debug = !debug
	emit_signal("debug_changed", debug)
