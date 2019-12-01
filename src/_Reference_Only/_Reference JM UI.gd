#Tree structure:

#     Main (Node)
# vvv Dialogue (Control)
# vvv Panel, Name (RichTextLabel), Frame (PanelContainer)
#     Speech (RichTextLabel)

#Scripts:

#Main.gd, Dialogue.gd, Speech.gd

#########
#Main.gd#
#########

extends Control

signal dialogue_toggled()

func _ready():
	connect("dialogue_toggled", $Dialogue, "on_dialogue_toggle") #$Dialogue is a base Control node

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"): #currently a debug way to bring up text
		emit_signal("dialogue_toggled")

#############
#Dialogue.gd#
#############

onready var open = false
onready var moving = false
onready var size = get_size()
onready var open_position = Vector2(0, 800 - size.y)
onready var closed_position = Vector2(0, 800)


func _ready():
	finalize_position(closed_position)

func _process(delta):
	# Move dialogue box?
	if moving:
		if open: #we are closing
			move_to(open_position, delta)
		else: #we are opening
			move_to(closed_position, delta)
	else:
		if open: #we are open
			finalize_position(open_position)
			$Panel/Speech.read_speech() #function could be replaced, path especially
		else: #we are open
			finalize_position(closed_position)
			$Panel/Speech.clear_speech() #function could be replaced, path especially

# Signal receiver, sets internal flag whether Dialogue should be open or closed.
func on_dialogue_toggle():
	if not moving:
		# If Dialogue is fully open and Speech hasn't been read completely,
		# jump Speech to the end of its text.
		# Otherwise, toggle open state and set Dialogue in motion.
		if open and not $Panel/Speech.has_read:
			$Panel/Speech.finalize_speech()
		else:
			open = !open
			moving = true
	else:
		moving = false

# Gradually moves Dialogue toward given position.
# Arguments:
#	position: Vector2 - the end position to move Dialogue toward.
#	delta: float - the elapsed frame time.
func move_to(position: Vector2, delta: float):
	var current = get_position()
	var difference = position - current
	var movement = (difference / MOVE_DIVISOR as float) * delta
	
	# If movement is down to the fractions, just lock in final place.
	if abs(difference.y) <= 1.0:
		finalize_position(position)
	else:	
		set_position(current + movement)

# The function "finalize_position" jumps Dialogue to given position, and stops movement processing.
# Arguments:
#	position: Vector2 - the position to jump Dialogue to.
func finalize_position(position: Vector2):
	set_position(position)
	moving = false

###########
#Speech.gd#
###########

extends RichTextLabel
#check onready vs. not onready vars in docs
onready var reading = false
onready var FramesPerLetter: int = 0
enum TextSpeeds {SLOW = 5, MEDIUM = 3, FAST = 1}

#this one is best handled on your own with the "current character" property built into the richtextlabel

func ReadSpeech():
	if reading:
		# Count frames until next letter to be printed
		frames += 1
		# If ready to print the next letter (based on text speed):
		if frames >= text_speed:
			# Print the next letter and reset the counter.
			if current_char < finaltext.length():
				text += finaltext[current_char]
			else:
				finalize_speech()
			frames = 0
			current_char += 1
	elif not has_read:
		reading = true
