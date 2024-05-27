extends Node2D
@onready var main = $".."
@onready var bird = $"../Bird"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if main.game_over == false:
		position.x -= main.game_speed

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

#add score on player passing pipe
func _on_score_counter_area_exited(area):
	if area.is_in_group("bird") && main.game_over == false:
		main.add_score()

