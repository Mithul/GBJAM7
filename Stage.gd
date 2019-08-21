extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_complete
signal remaining_enemies_update

onready var tilemap = $Map/TileMap

export var level = 1
export var enemy : PackedScene

var num_enemies = 0

# Called when the node enters the scene tree for the first time.
func init():
	randomize()
	var grass_tile_id = tilemap.tile_set.find_tile_by_name("grass")
	
	for cell_pos in tilemap.get_used_cells():
		if tilemap.get_cell(cell_pos.x, cell_pos.y) == grass_tile_id:
			var cell_glob_pos = tilemap.map_to_world(cell_pos)
			if $Player.global_position.distance_to(cell_glob_pos) < 32:
				continue
			if randf() < 0.01*level/2:
				var new_enemy = enemy.instance()
				new_enemy.max_health = level*100/4
				new_enemy.score = level*20
				new_enemy.connect("on_death", self, "_on_enemy_died")
				new_enemy.global_position = cell_glob_pos + Vector2(8, 8)
				add_child(new_enemy)
				num_enemies += 1
	emit_signal("remaining_enemies_update", num_enemies)
	
func reset():
	level = 1
	$Player.reset()
	init()
	
func _ready():
	init()
		

func _on_enemy_died(enemy):
	num_enemies -= 1
	emit_signal("remaining_enemies_update", num_enemies)
	$Player.update_score(enemy.points)
	print("ENEMY", num_enemies)
	if num_enemies == 0:
		level += 1
		emit_signal("level_complete")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(tilemap.map_to_world(Vector2(0,1)))


func _on_GUI_gui_done():
	init()
