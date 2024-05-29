extends ParallaxBackground

const  backgroundSpeed = 150

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.x -= backgroundSpeed*delta
