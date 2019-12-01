extends Actor #look at Actor.gd for more details

const MAX_CHARGES = 1 #increasing this beyond 1 creates infinite aircharges
const CROUCH_DIVISOR = 2.3 #is free to be changed
var aircharges = 1 #can be incremented with pickups/powerups

var direction: = Vector2.ZERO #essential
export var stomp_impulse = 700.0 #amount launched upward when stomping an enemy

#physics-related states
var canJump = true
var isCrouching = false

#all "looks" are passed as one variable:
var lookState = Vector2(1,1)
#X:
#(-1 = left, 1 = right)
#Y:
#(-3 = talking, -2 = crouch, -1 = falling, 0 = stand, 1 = jump, 2 = double-jump, 3 = glide)
#and there's potential to add Z, which would overwrite anything in X and Y
#actions such as earning an item, entering a door, cutscene animations, etc.

###########
#CALLBACKS#
###########
func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

###################
#LOOKSTATE CHANGES#
###################

#Pseudocode version below:

func _input(event: InputEvent) -> void:
	
	#crouching vs standing vs jumping
	if Input.is_action_just_pressed("ui_down"): #if we're crouching, we're crouching
		lookState.y = -2
	elif Input.is_action_just_released("ui_down"): #if we stop crouching, what are we doing?
		if Input.is_action_pressed("ui_accept"): #we were jumping
			lookState.y = 1
		elif not is_on_floor(): #we were falling
			lookState.y = -1
		
	elif not Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("ui_accept"):
			lookState.y = 1
		elif not is_on_floor():
			lookState.y = -1
		else:
			lookState.y = 0
	
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		aircharges -= 1 #this currently invalidates more than 2 mid-air jumps in physics_process
		lookState.y = 2
		
	##############################
	#Pseudocode version of above:#
	##############################
	#if down:
	#	state crouch
	#else if stopping down:
	#	if jumping:
	#		state jump
	#	else if not on floor:
	#		state falling
	
	#if not down:
	#	if jumping:
	#		state jump
	#	else if not on floor:
	#		state falling
	#	else (not jumping and on_floor():
	#		state stand
	
	#if jumping and not on floor and have aircharges:
	#	remove an aircharge
	#	state doublejump
	
	###############
	#X Look Stuff:#
	###############
	
	#Which direction are we looking?
	if (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") ) == 1:
		lookState.x = 1
	elif (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") ) == -1:
		lookState.x = -1
	else:
		lookState.x = 0
	changelook()

func changelook(): #what happens using lookState?
	#X look direction:
	if lookState.x == -1:
		$Sprite.frame = 1 #tentative
	elif lookState.x == 1:
		$Sprite.frame = 0 #same
	#Y state:
	if lookState.y == -2:
		$Sprite.scale.y = 0.75 #tentative
	elif lookState.y == 1:
		$Sprite.scale.y = 1.25 #very tentative
	elif lookState.y == 2:
		$Sprite.scale.y = 1.4 #incredibly tentative
	else:
		$Sprite.scale.y = 1

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("ui_accept") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)
	if is_on_floor(): #to determine canJump state
		canJump = true
		aircharges = MAX_CHARGES
		if Input.is_action_pressed("ui_down") and is_on_floor():
			isCrouching = true
		else:
			isCrouching = false
	elif aircharges > 0:
		canJump = true
	else:
		canJump = false


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-Input.get_action_strength("ui_accept") if canJump and  Input.is_action_just_pressed("ui_accept") else 0.0 #canJump replaces "is_on_floor()"
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	if isCrouching:
		velocity.x = (speed.x / CROUCH_DIVISOR) * direction.x
	else:
		velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted and aircharges > 0:
		velocity.y = (velocity.y / 3)
	return velocity

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out
	#var stomp_jump: = -speed.y if Input.is_action_pressed("ui_accept") else -stomp_impulse
	#return Vector2(linear_velocity.x, stomp_jump)

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	print("ouch!")

func updateLookstate(x: int, y: int):
	print (x as String + " " + y as String)