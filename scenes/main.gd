extends Node

@export var pipe_scene : PackedScene

## determine game state
var game_running : bool 
var game_over : bool
var scroll ## move images across screen smoothly
var score
const SCROLL_SPEED : int = 4 ## game speed
var screen_size : Vector2i
var ground_height : int
var pipes : Array ## store all the created pipes
## control pipe generation
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
## reset variables
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide() ## only game over scene when bird dies
	get_tree().call_group("pipes", "queue_free") ## delete all pipes in group "pipes" (the "previous pipes")
	pipes.clear()
	generate_pipes() ## generate starting pipes
	$Bird.reset()
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				## on click, either start game or continue flapping bird
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		## reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		## move ground node
		$Ground.position.x = -scroll
		## move pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout():
	generate_pipes()

## generate pipes at random heights
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY ## slide in from right instead of appearing
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE) ## random value
	pipe.hit.connect(bird_hit) ## trigger func bird_hit
	pipe.scored.connect(scored) ## when scored signal emitted, link to scored function
	add_child(pipe) ## add a scene as the child of main scene
	pipes.append(pipe) ## keep track of pipes in array

## increase score and update label
func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

## end game if bird goes above screen
func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Bird.flying = false 
	game_running = false
	game_over = true

func bird_hit():
	$Bird.falling = true
	stop_game()

## stop bird from falling past the ground
func _on_ground_hit():
	$Bird.falling = false
	stop_game()

# restart game when restart signalled
func _on_game_over_restart():
	new_game()
