extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var InternalX = 0
var InternalY = 0

func UpdatePlayer():
	#1 intx = 64 externalx
	#1 inty = 50 externaly
	position.x = 0
	position.y = 0

func _physics_process(delta: float) -> void:
	
	#hexagonal movement means six movement axis, up/down, topleft/bottomright, bottomleft/topright
	if Input.is_action_just_pressed("LEFT"):
		InternalX -= 1
		UpdatePlayer()
	elif Input.is_action_just_pressed("RIGHT"):
		InternalX += 1
		UpdatePlayer()
	elif Input.is_action_just_pressed("LOWN"):
		InternalY += 1
		InternalX -= 1
		UpdatePlayer()
	elif Input.is_action_just_pressed("ROWN"):
		InternalY += 1
		InternalX += 1
		UpdatePlayer()
	elif Input.is_action_just_pressed("LUP"):
		InternalY -= 1
		InternalX -= 1
		UpdatePlayer()
	elif Input.is_action_just_pressed("RUP"):
		InternalY -= 1
		InternalX += 1
		UpdatePlayer()
