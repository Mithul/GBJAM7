extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 20
export var fireball : PackedScene

onready var animator = $Sprite/AnimationPlayer

var facing_direction = constants.LEFT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		print("Fireball")
		var new_fireball = fireball.instance()
		new_fireball.position = $projectile_spawn_position.position
		add_child(new_fireball)
		new_fireball.init(facing_direction)
	
		
func _on_Area2D_body_entered(body):
	print(body)
