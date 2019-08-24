extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 40
# Called when the node enters the scene tree for the first time.

var launched_entity_type = null
var type = constants.PROJECTILE

func init(direction):
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


func die():
	$death_particles.emitting = true
	queue_free()

func _on_lifetime_timeout():
	die()

func _on_Area2D_area_entered(area):
	var entity = area.get_parent()
	if entity.type == launched_entity_type:
		return
	var should_die = true
	if entity.has_method("incur_damage"):
		if entity.incur_damage(10) == false:
			should_die = false
	if should_die:
		die()
