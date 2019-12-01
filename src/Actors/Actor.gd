extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP #this lets us stay on the floor

export var speed: = Vector2(350.0, 500.0) #speed and jump amount on a per-actor basis
export var gravity: = 3500.0 #gravity on a per-actor basis
export var StartingMultiplier: int = -1 #AI only, if set to -1, they start moving left

var _velocity: = Vector2.ZERO #starts each actor with 0 velocity

func _physics_process(delta: float) -> void: #provides actors with _velocity as the updated velocity var
	_velocity.y += gravity * delta
