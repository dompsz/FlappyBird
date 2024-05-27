extends CharacterBody2D
@onready var timer = $Spacebar_cooldown
@onready var bird = $BirdSprite
@onready var main = $".."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_jump = true
const JUMP_VELOCITY = -330.0

func _ready():
	timer.timeout.connect(enable_jump)

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("Jump") && can_jump == true:
		velocity.y = JUMP_VELOCITY
		can_jump = false
		timer.start()
	
	move_and_slide()

func enable_jump():
	can_jump = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("pipes"):
		death()
	
func death():
	timer.stop()
	can_jump = false
	bird.play("death")
	main.death_pause()
