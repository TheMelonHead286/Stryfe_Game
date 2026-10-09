extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	#hexagonal movement means six movement axis, up/down, topleft/bottomright, bottomleft/topright
	if Input.is_action_just_pressed("LEFT"):
		position.x -= 64
	elif Input.is_action_just_pressed("RIGHT"):
		position.x += 64
	elif Input.is_action_just_pressed("LOWN"):
		position.y += 64
		position.x -= 32
	elif Input.is_action_just_pressed("ROWN"):
		position.y += 64
		position.x += 32
	elif Input.is_action_just_pressed("LUP"):
		position.y -= 64
		position.x -= 32
	elif Input.is_action_just_pressed("RUP"):
		position.y -= 64
		position.x += 32
