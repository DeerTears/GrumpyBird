extends Area2D

func _ready():
	Global.rubyMaxA += 1
	$Sprite/Anim.current_animation = "Static"
	$Sparkles.emitting = true

func _on_Anim_animation_finished(anim: String):
	if anim == "Fadeout":
		queue_free()

func _on_Ruby_body_entered(body: PhysicsBody2D) -> void:
	set_deferred("Collision.disabled", true)
	set_deferred("Sparkles.emitting", false)
	set_deferred("Collected.emitting", true)
	set_deferred("monitoring",false)
	Global.rubyA += 1
	$Sprite/Anim.play("Fadeout")