extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var tilemap = $Map/TileMap

export var level = 1
export var enemy : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var grass_tile_id = tilemap.tile_set.find_tile_by_name("grass")
	
	for cell_pos in tilemap.get_used_cells():
		if tilemap.get_cell(cell_pos.x, cell_pos.y) == grass_tile_id:
			var cell_glob_pos = tilemap.map_to_world(cell_pos)
			if $Player.global_position.distance_to(cell_glob_pos) < 32:
				continue
			if randf() < 0.1*level:
				var new_enemy = enemy.instance()
				new_enemy.global_position = cell_glob_pos + Vector2(8, 8)
				add_child(new_enemy)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(tilemap.map_to_world(Vector2(0,1)))
