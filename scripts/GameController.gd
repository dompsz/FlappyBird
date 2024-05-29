extends Node2D
@onready var top = load("res://scenes/top_pipe.tscn")
@onready var bot = load("res://scenes/bottom_pipe.tscn")
@onready var gb = load("res://scenes/ground_block.tscn")
@onready var timer = $PipeSpawnTimer
@onready var score_label = $UI/ScoreLabel
@onready var bird = $Bird
@onready var game_over_sprite = $UI/GameOverSprite
@onready var high_score_label = $UI/HighScoreLabel

#create save file
var save_data:SaveData

#variable for delta time counting
var i = 0	

var game_over = false
var game_speed = 1
var score = 0

var min_height = 210
var max_height = 450
var spawn_pos_x = 500

#height from pipe to pipe
var gaps_size = 150

#difficulty modifiers
var minimum_gaps_size = 80
var shorten_gaps = 1
var timer_minimum = 1.2
var speed_increase = 0.05

#Initially stop the game
func _ready():
	save_data = SaveData.load_or_create()
	high_score_label.text = "High Score: " + str(save_data.high_score)
	get_tree().paused = true
	
#pause everything but the player for falling effect
func death_pause():
	game_over = true
	game_over_sprite.visible = true
	if save_data.high_score < score:
		save_data.high_score = score
		high_score_label.text = "High Score: " + str(score)
		save_data.save()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#blocks input except for restart
	if game_over == false:
		#spawn new background on the right after 400 delta
		if i == 397 && get_tree().paused == false:
			i = 0
			spawn_bg()
		if get_tree().paused == false:
			i += 1
		#start the game on input
		if Input.is_action_just_pressed("Jump") && get_tree().paused == true :
			spawn_bg()
			play()
	#restart with R
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
	
#start time
func play():
	get_tree().paused = false
	game_over = false
	start()

#start timers
func start():
	timer.start()
	timer.timeout.connect(spawn_pipes)
	
#spawn pipes based on timer
func spawn_pipes():
	var rand_height = get_rand()
	
	var t = top.instantiate()
	t.position.x = spawn_pos_x
	t.position.y = rand_height
	add_child(t)

	var b = bot.instantiate()
	b.position.x = spawn_pos_x
	b.position.y = rand_height + gaps_size
	add_child(b)
	
	restart_pipe_timer()

#restart timer and increase difficulty
func restart_pipe_timer():
	if timer.wait_time > timer_minimum:
		timer.set_wait_time(timer.wait_time - speed_increase)
		
	if gaps_size > minimum_gaps_size:
		gaps_size -= shorten_gaps

	timer.start()

#rand height getter
func get_rand():
	var a =	randi_range(min_height, max_height)
	return a
	
#add score and update label
func add_score():
	score += 1
	score_label.text = str(score)

#spawn background
func spawn_bg():
	var g = gb.instantiate()
	g.position.x = 599
	g.position.y = 710
	add_child(g)
