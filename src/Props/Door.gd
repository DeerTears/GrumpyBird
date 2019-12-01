extends Area2D

func _on_Door_body_entered(body: PhysicsBody2D) -> void:
	$Sprite.frame = 1

func _on_Door_body_exited(body: PhysicsBody2D) -> void:
	$Sprite.frame = 0
