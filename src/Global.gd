extends Node

#Place this script in the "AutoLoad" portion of project settings, set Singleton to "Enable"
#Global.goto_scene("res://FOLDER/SCENENAME.tscn")

#required for scene switching
var current_scene = null

#shared variables across levels
var health: int = 10

#stage A
var coinsA: int = 0
var coinsMaxA: int = 0
var rubyA: int = 0
var rubyMaxA: int = 0

func _ready():
    var root = get_tree().get_root() #Global needs to be able to call functions of the root
    current_scene = root.get_child(root.get_child_count() - 1) #returns a zero-indexed child count

func goto_scene(path):
    call_deferred("_deferred_goto_scene", path) #we must call deferred, or else our code will be interrupted when we switch scenes and cause crashes

func _deferred_goto_scene(path): #it is now safe to remove the current scene
	current_scene.free() #delete old scene
	var s = ResourceLoader.load(path) #load the new scene
	current_scene = s.instance() #instance the new scene
	get_tree().get_root().add_child(current_scene) #add it to the active scene, as a child of root

#func add_score(score:int):
#	print(score as String + " added")
#this function could be called as "Global.add_score(1)" anywhere in the game

#Procedural loading: https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html#doc-background-loading