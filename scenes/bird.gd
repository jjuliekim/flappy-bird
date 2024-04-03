extends CharacterBody2D

const GRAVITY : int = 1000 ## How quickly the bird drops
const MAX_VEL : int = 600 ## Limit max fall speed
const FLAP_SPEED : int = -400 ## How high the bird jumps up
var flying : bool = false ## flag, active as long as bird hasn't collided with anything
var falling : bool = false ## flag, active when bird hits pipe and falls to ground
const START_POS = Vector2(100, 400) ## starting coords of bird

## called when the node enters the scene tree for the first time
func _ready():
	reset()
	
## initialize variables
func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

## called every frame. 'delta' is the elapsed time since the previous frame
func _physics_process(delta):
	## check if bird is in the air, apply gravity
	if flying or falling:
		velocity.y += GRAVITY * delta
		## terminal velocity, limit velocity
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		## as long as the bird is flying, rotate and play animation
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2) ## face down
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else: ## bird is not in the air
		$AnimatedSprite2D.stop()
		
## allow bird to fly up
func flap():
	velocity.y = FLAP_SPEED
	
