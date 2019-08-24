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

var nav2d : Navigation2D = null

var follows = null

var is_follows_seen = false

var follows_when_not_visible = true
var follows_around_obstacles = false

var line2d
var path : PoolVector2Array = []

var impatience_wait_time = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	hit_entities = []
	$Healthbar.value = health*20/max_health
	is_follows_seen = false
	line2d = $Line2D
	self.remove_child(line2d)
	get_node("/root").add_child(line2d)
	$Impatience.wait_time = impatience_wait_time
	$Impatience.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var movement = Vector2()
	
	if follows_around_obstacles == false:
		if follows != null:
			movement = (follows.global_position - global_position).normalized()
		
		if abs(movement.x) > abs(movement.y):
			move_and_slide(Vector2(movement.x, 0).normalized()*speed)
		else:
			move_and_slide(Vector2(0, movement.y).normalized()*speed)
	elif path != null:
		var start_point := position
		var distance = speed*delta
		for i in range(path.size()):
			var distance_to_next := start_point.distance_to(path[0])
			if(distance <= distance_to_next and distance >= 0) and distance_to_next > 0:
				position = start_point.linear_interpolate(path[0], distance/distance_to_next)
				break
			elif distance < 0:
				position = path[0]
			distance -= distance_to_next
			start_point = path[0]
			path.remove(0)
				
	
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
		if follows != null and follows.has_method("update_mana"):
			var mana_recovered = 5 * scale.x + max_health/2
			follows.update_mana(mana_recovered)
			

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


func _on_PathFinder_timeout():
	if nav2d != null and follows != null and follows_around_obstacles:
		var new_path := nav2d.get_simple_path(global_position, follows.global_position)
		line2d.points = new_path
		path = new_path
		


func _on_Impatience_timeout():
	follows_around_obstacles = true
	$AnimationPlayer.play("Grow")
