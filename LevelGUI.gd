extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal gui_done

var level = 1
var enemies_remaining = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Static_level.visible = false
	$EnemiesLeft.visible = false
	$Level.text = "Level "+str(level)
	$Static_level.text = "Level "+str(level)
	show()
	
func show():
	$Level.visible = true
	$Static_level.visible = false
	$EnemiesLeft.visible = false
	$Level.text = "Level "+str(level)
	$Static_level.text = "Level "+str(level)
	$Display_timer.start()

func _on_Display_timer_timeout():
	$Level.visible = false
	$Static_level.visible = true
	$EnemiesLeft.visible = true
	$EnemiesLeft.text = "Enemies : "+str(enemies_remaining)
	emit_signal("gui_done")


func _on_Stage_level_complete():
	level += 1
	show()


func _on_Stage_remaining_enemies_update(num_enemies):
	enemies_remaining = num_enemies
	$EnemiesLeft.text = "Enemies : "+str(enemies_remaining)
