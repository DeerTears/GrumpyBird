extends "res://src/Actors/Actor.gd"

var slowdown = false
var touching_player = false

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = speed.x * StartingMultiplier
	StartingMultiplier += 2 #this seriously needs a proper direction implementation
	$Sprite.frame = StartingMultiplier #this seriously needs a proper direction implementation
	StartingMultiplier -= 2 #this seriously needs a proper direction implementation

func _on_TalkBox_body_entered(body: PhysicsBody2D) -> void:
		if not is_on_wall():
			if body.global_position.x > $Collision.global_position.x:
				$Sprite.frame = 0
			else:
				$Sprite.frame = 1
			_velocity.x = 0
			touching_player = true

func _on_TalkBox_body_exited(body: PhysicsBody2D) -> void:
	resume_walking()

func resume_walking():
	if $Sprite.frame == 1:
		_velocity.x = speed.x * -1
	else:
		_velocity.x = speed.x
	touching_player = false

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall() and not touching_player:
		_velocity.x *= -1.0
		change_look()
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y	
	
func change_look():
	if $Sprite.frame == 1:
		$Sprite.frame = 0
	else:
		$Sprite.frame = 1

