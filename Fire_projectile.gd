extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 40
# Called when the node enters the scene tree for the first time.

func init(direction):
	print("INIT", direction)
	if direction == constants.UP:
		set_rotation(deg2rad(-90))
	elif direction == constants.DOWN:
		set_rotation(deg2rad(90))
	elif direction == constants.LEFT:
		set_rotation(deg2rad(180))
	elif direction == constants.RIGHT:
		set_rotation(deg2rad(0))

func _ready():
	$flight_particles.local_coords = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	translate((Vector2(1,0)*speed*delta).rotated(rotation))


func _on_lifetime_timeout():
	$death_particles.emitting = true
	queue_free()
