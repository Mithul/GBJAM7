extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 40
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(1,0)*speed*delta


func _on_lifetime_timeout():
	$death_particles.emitting = true
	queue_free()
