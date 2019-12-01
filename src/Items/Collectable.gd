extends Area2D

func _ready():
	Global.coinsMaxA += 1
	$Sprite/Anim.current_animation = "Static"
	$Sparkles.emitting = true

func _on_Collectable_body_entered(body: PhysicsBody2D):
	set_deferred("Collision.disabled", true)
	set_deferred("Sparkles.emitting", false)
	set_deferred("Collected.emitting", true)
	set_deferred("monitoring",false)
	Global.coinsA += 1
	$Sprite/Anim.play("Fadeout")

func _on_Anim_animation_finished(anim: String):
	if anim == "Fadeout":
		queue_free()