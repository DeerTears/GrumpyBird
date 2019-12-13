extends Control

#Menu Button Callbacks
func _on_PlayButton_pressed() -> void:
	Global.goto_scene("res://scenes/LevelTemplate.tscn")
func _on_ExitButton_pressed() -> void:
	$QuitDialogue.popup()

#Dialogue Callbacks
func _on_QuitDialogue_confirmed() -> void:
	get_tree().quit()

func _on_TestButton_pressed() -> void:
	Global.goto_scene("res://scenes/TestLevel.tscn")