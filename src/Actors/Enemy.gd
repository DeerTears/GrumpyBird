extends "res://src/Actors/Actor.gd"

var slowdown = false
var touching_player = false

func _ready() -> void:
	set_physics_process(false)
	$CollisionShape2D.disabled = false
	_velocity.x = speed.x * StartingMultiplier
	StartingMultiplier += 2 #this seriously needs a proper direction implementation
	$Sprite.frame = StartingMultiplier #this seriously needs a proper direction implementation
	StartingMultiplier -= 2 #this seriously needs a proper direction implementation

func _on_AttackDetector_body_entered(body: PhysicsBody2D) -> void:
	Global.health -= 1
	print("ouch! lose " + Global.health as String + " health!")

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > $StompDetector.global_position.y:
		if not is_on_wall():
			_velocity.x = 0
			if body.global_position.x > $CollisionShape2D.global_position.x:
				$Sprite.frame = 0
				$Anim.play("AttackRight")
			else:
				$Sprite.frame = 1
				$Anim.play("AttackLeft")
			touching_player = true
	else:
		$CollisionShape2D.disabled = true
		queue_free()

func _on_Anim_animation_finished(anim_name: String) -> void:
	if $Sprite.frame == 1:
		_velocity.x = speed.x * -1
	else:
		_velocity.x = speed.x
	touching_player = false

#func _process(delta:float) -> void:
#	if not is_on_wall() and touching_player == true:
#		_velocity.x = 0
#	else:
#		last_velocity = _velocity.x

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
