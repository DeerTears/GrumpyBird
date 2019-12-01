extends Control

var open = false
var moving = false

const REST_OPEN = Vector2(0,0)
const REST_CLOSED = Vector2(1280,0)
const MOVE_DIVISOR = 0.15 #how much the smooth movement is divided by, .12 was the starting point

func _on_SettingsButton_pressed() -> void:
	if moving: #If this button is interrupting the window movement...
		if open: # and it's already open
			finalize_position(REST_CLOSED) #then finish closing it
			debug(get_position(), REST_CLOSED)
		if open == false: # and it's not yet open
			finalize_position(REST_OPEN) #then finish opening it
			debug(get_position(), REST_OPEN)
	if not moving: # otherwise
		moving = true # let _process handle things

func _process(delta: float):
	if moving: # we're supposed to be moving!
		if not open: # but we're not open yet!
			move_to(REST_OPEN, delta) # so let's open!
			#ui_interp_debug(get_position(), REST_OPEN)
		elif open: # but we ARE open already...
			move_to(REST_CLOSED, delta) # so let's close!
			#ui_interp_debug(get_position(), REST_OPEN)

#UI Smoothing

func move_to(target: Vector2, delta: float): #const positions are passed to target, _process gives us delta
	var current = get_position()
	var difference = target - current
	var movement = (difference / MOVE_DIVISOR as float) * delta
	# If movement is down to the fractions, just lock us in our final place.
	if abs(difference.x) <= 1.0: #watch out for this difference.x if the intent is to slide in from a Y position!
		finalize_position(target)
	# Otherwise, add-on the amount we're moving so far
	else:
		set_position(current + movement)
		moving = true
#Arguments of move_to:
# target - The Vector2 we want to reach
# delta - Time elapsed

#Variables of move_to:
# current - Old position
# difference - Amount to be moved between our target and our current positions
# movement - broken down into chunks by the MOVE_DIVISOR to be processed by delta

#Used when smoothing is finished or skipped
func finalize_position(PassedPosition: Vector2):
	moving = false
	if PassedPosition == REST_OPEN:
		open = true
	elif PassedPosition == REST_CLOSED:
		open = false
	set_position(PassedPosition)
	debug(PassedPosition, PassedPosition)

func debug(current: Vector2, target: Vector2):
	if current == target:
		print("UI Movement Successful! Open: " + open as String + " & Moving: " + moving as String)
	else:
		print("UI Movement Failed. Open: " + open as String + " & Moving: " + moving as String + "Currently at: " + current as String + "Aimed for: " + target as String)

#func ui_interp_debug(current: Vector2, target: Vector2):
#	print("Currently at: " + current as String + " & Aiming for: " + target as String)
