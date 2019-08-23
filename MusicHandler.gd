extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var play_enemy_seen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func enemy_visible():
	if $EnemySeen.playing == false:
		play_enemy_seen = true

func _on_Background_finished():
	print("Complete")


func _on_EnemySeen_finished():
	print("Completee")


func _on_beat_timeout():
	if play_enemy_seen == true:
		$EnemySeen.play()
		play_enemy_seen = false
