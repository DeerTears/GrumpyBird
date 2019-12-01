extends Control

var open = false
var moving = false
const REST_OPEN = Vector2(0,0)
const REST_CLOSED = Vector2(1280,0)
const MOVE_DIVISOR = 0.1 #the lower the number, the faster UI moves

func _ready() -> void:
	set_position(REST_CLOSED)

#Pause Window
func _on_Resume_pressed() -> void:
	get_tree().paused = false
	moving = true

func _on_Restart_pressed() -> void:
	get_tree().paused = false
	#get_tree().current_scene = Global.current_scene #this doesn't work more than once for some reason
	get_tree().reload_current_scene()

func _on_Exit_pressed() -> void:
	$Quit.show()
	disable_pause_menu_buttons()

#Quit Window
func _on_OK_pressed() -> void:
	get_tree().quit()

func _on_Cancel_pressed() -> void:
	$Quit.hide()
	enable_pause_menu_buttons()

func _process(delta: float):
	if not moving:
		if Input.is_action_just_pressed("ui_pause"):
			moving = true #get the ball rolling
			get_tree().paused = true #and pause
			return
	if moving:
		if open:
			if Input.is_action_just_pressed("ui_pause"):
				pauseInterrupt(REST_CLOSED)
			else:
				move_to(REST_CLOSED, delta)
			get_tree().paused = false #in any case, unpause as soon as we're trying to remove this window
			#this might be causing a current double-pause problem
			$Quit.hide()
			enable_pause_menu_buttons()
		else: #closed
			if Input.is_action_just_pressed("ui_pause"):
				pauseInterrupt(REST_OPEN)
			else:
				move_to(REST_OPEN, delta)

func move_to(target: Vector2, delta: float):
	var current = get_position() #old position
	var difference = target - current
	var movement = (difference / MOVE_DIVISOR as float) * delta
	if abs(difference.x) <= 1.1: #change to difference.y if sliding from above/below
		finalize_position(target) #prevents infinitely smaller movements
	else:
		set_position(current + movement)
		moving = true

func pauseInterrupt(target: Vector2):
	ui_interp_debug()
	if moving:
		finalize_position(target)

#Used when smoothing is finished or skipped
func finalize_position(PassedPosition: Vector2):
	moving = false
	if PassedPosition == REST_OPEN:
		get_tree().paused = true
		open = true
	elif PassedPosition == REST_CLOSED:
		open = false
	set_position(PassedPosition)
	ui_interp_debug()

func disable_pause_menu_buttons():
	$PauseBG/Container/Exit.disabled = true
	$PauseBG/Container/Restart.disabled = true
	$PauseBG/Container/Resume.disabled = true

func enable_pause_menu_buttons():
	$PauseBG/Container/Exit.disabled = false
	$PauseBG/Container/Restart.disabled = false
	$PauseBG/Container/Resume.disabled = false

func ui_interp_debug():
	print("Moving: " + moving as String, ". Open: " + open as String + ".")
