extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 10
export var max_health = 100
var health = 0
signal on_death
signal visible_on_camera

var hit_entities : Array

var type = constants.ENEMY

export var points = 20

var follows = null

var is_follows_seen = false

var follows_when_not_visible = true
var follows_around_obstacles = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	hit_entities = []
	$Healthbar.value = health*20/max_health
	is_follows_seen = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var movement = Vector2()
	if follows != null:
		movement = (follows.global_position - global_position).normalized()
	
	if abs(movement.x) > abs(movement.y):
		move_and_slide(Vector2(movement.x, 0).normalized()*speed)
	else:
		move_and_slide(Vector2(0, movement.y).normalized()*speed)
	
	if randf() < 0.01:
		if $AnimatedSprite.animation != 'Death':
			$AnimatedSprite.play("Blink")
	else:
		if $AnimatedSprite.animation == 'Blink' and $AnimatedSprite.frames.get_frame_count("Blink") == $AnimatedSprite.frame + 1:
			$AnimatedSprite.play("Idle")
		elif $AnimatedSprite.animation == 'Death' and $AnimatedSprite.frames.get_frame_count("Death") == $AnimatedSprite.frame + 1:
			queue_free()

func follow(entity):
	follows = entity

func die():
	if $AnimatedSprite.animation != 'Death':
		speed = 0
		$AnimatedSprite.play("Death")
		$death_sound.play()
		emit_signal("on_death", self)

func incur_damage(damage):
	if health < 0:
		return false
	health -= damage
	$Healthbar.value = health*20/max_health
	if health <= 0:
		die()
	
func _on_Area2D_area_entered(area):
	var entity = area.get_parent()
	hit_entities.append(entity)
	var should_die = true
	if entity.has_method("incur_damage"):
		if entity.incur_damage(10) == false:
			should_die = false
	if $HitTimer.is_stopped():
		$HitTimer.start()


func _on_HitTimer_timeout():
	for entity in hit_entities:
		var should_die = true
		if entity.has_method("incur_damage"):
			if entity.incur_damage(10) == false:
				should_die = false


func _on_HitBox_area_exited(area):
	var entity = area.get_parent()
	var pos = hit_entities.find(entity)
	if pos != -1:
		hit_entities.remove(pos)
	if hit_entities.size() == 0:
		$HitTimer.stop()


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	emit_signal("visible_on_camera")
