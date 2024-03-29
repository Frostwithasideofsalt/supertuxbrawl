extends Node2D
class_name Stage

# Customisable variables
@export var stage_bounds: Vector2 = Vector2(600,300)
@export var stage_respawn_point: Vector2 = Vector2(0, -150)

# Non-customisable variables
@onready var stage_tile_map: TileMap = $StageTileMap
var use_hazards: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
