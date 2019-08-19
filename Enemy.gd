extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if randf() < 0.01:
		$AnimatedSprite.play("Blink")
	else:
		if $AnimatedSprite.animation == 'Blink' and $AnimatedSprite.frames.get_frame_count("Blink") == $AnimatedSprite.frame + 1:
			$AnimatedSprite.play("Idle")

