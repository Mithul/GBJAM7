extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var stage = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOverText.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_player_dead():
	get_tree().paused = true
	$GameOverText.visible = true
	$GameOverWait.start()


func _on_GameOverWait_timeout():
	get_tree().paused = false
	$GameOverText.visible = false
	stage.reset()
