extends Sprite2D
@onready var main = $".."

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if main.game_over == false:
		position.x -= main.game_speed
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

