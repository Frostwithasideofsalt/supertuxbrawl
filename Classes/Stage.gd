extends Node2D
class_name Stage

@onready var stage_tile_map: TileMap = $StageTileMap
@export var stage_bounds: Vector2 = Vector2(600,300)
@export var stage_respawn_point: Vector2 = Vector2(0, -150)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
