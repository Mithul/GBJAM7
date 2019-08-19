extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$Healthbar.value = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if randf() < 0.01:
		if $AnimatedSprite.animation != 'Death':
			$AnimatedSprite.play("Blink")
	else:
		if $AnimatedSprite.animation == 'Blink' and $AnimatedSprite.frames.get_frame_count("Blink") == $AnimatedSprite.frame + 1:
			$AnimatedSprite.play("Idle")
		elif $AnimatedSprite.animation == 'Death' and $AnimatedSprite.frames.get_frame_count("Death") == $AnimatedSprite.frame + 1:
			queue_free()

func die():
	if $AnimatedSprite.animation != 'Death':
		$AnimatedSprite.play("Death")

func incur_damage(damage):
	if health < 0:
		return false
	health -= damage
	$Healthbar.value = health/5
	if health < 0:
		die()
	