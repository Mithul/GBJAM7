extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal player_dead

export var speed = 20
export var fireball : PackedScene

onready var animator = $Sprite/AnimationPlayer

var facing_direction = constants.LEFT
var health = 100
var mana = 100
var score = 0

var type = constants.PLAYER

func reset():
	health = 100
	mana = 100
	score = 0
	update_health(0)
	update_mana(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/HP.value = health
	$GUI/MP.value = mana
	$GUI/Score.text = "Score : "+str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func move(delta):
	var movement = Vector2()
	if Input.is_action_pressed("ui_down"):
		movement.y = 1
		animator.play("WalkDown")
		facing_direction = constants.DOWN
	elif Input.is_action_pressed("ui_left"):
		movement.x = -1
		animator.play("WalkLeft")
		facing_direction = constants.LEFT
	elif Input.is_action_pressed("ui_up"):
		movement.y = -1
		animator.play("WalkUp")
		facing_direction = constants.UP
	elif Input.is_action_pressed("ui_right"):
		movement.x = 1
		animator.play("WalkRight")
		facing_direction = constants.RIGHT
	else:
		animator.stop(false)
		
	movement = move_and_slide(movement*speed, Vector2(0, -1))	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			print(collision)
	
func _physics_process(delta):
	move(delta)
	
	if Input.is_action_just_pressed("ui_select"):
		if mana >= 5:
			print("Fireball")
			var new_fireball = fireball.instance()
			new_fireball.launched_entity_type = type
			new_fireball.global_position = $projectile_spawn_position.global_position
			get_node("/root/Main").add_child(new_fireball)
			new_fireball.init(facing_direction)
			update_mana(-10)
			
func update_mana(value):
	mana += value
	$GUI/MP.value = mana
	
func update_score(value):
	score += value
	$GUI/Score.text = "Score : "+str(score)
	
func update_health(value):
	health += value
	$GUI/HP.value = health
	if health <= 0:
		emit_signal("player_dead")
	
func incur_damage(value):
	print(health)
	update_health(-value)
	return false
		
func _on_Area2D_body_entered(body):
	print(body)

func _on_ManaRegen_timeout():
	update_mana(5)
