extends Node
class_name MatchManager

@onready var _game_timer = Timer.new()

func _ready():
	_game_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
