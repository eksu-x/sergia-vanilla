extends Node2D
var P = preload("res://scene/scd_menu.tscn")
var CAM = preload("res://scene/game_cam.tscn")
onready var parallax = get_node("menu")
onready var givenPLayer = psm.player.instance()
onready var givenOpponent = psm.opponent.instance()
var nombre_joueur = 0
onready var cam = get_node("cam")



func _ready():
	SpawnChosenCharacters()
	get_tree().paused = false
	Engine.time_scale = 1
	pass

func _physics_process(delta):
	#cam.set_script(cam_script)
	if Input.is_action_pressed("pause"):
		#if get_tree().paused == false:
		var P = preload("res://scene/scd_menu.tscn").instance()
		parallax.add_child(P)
	#if Input.is_action_pressed("shield0"):
	#	get_tree().change_scene("res://scene/main_menu.tscn")
	#	self.queue_free()
	pass # Replace with function body.

		
			
func SpawnChosenCharacters():
	givenPLayer.position.x = 160
	givenPLayer.position.y = 857
	call_deferred("add_child", givenPLayer)
	givenPLayer.set_controller(0)
	
	givenPLayer.name = "Player1"
	

	givenOpponent.position.x = 1748
	givenOpponent.position.y = 879
	call_deferred("add_child", givenOpponent)
	givenOpponent.set_controller(1)
	givenOpponent.name = "Player2"
	print(get_path())
	var cam_i = CAM.instance()
	call_deferred("add_child", cam_i)
	
	
	#cam.set_script(cam_script)
	
func set_on_cam(nombre_joueur):
	print(nombre_joueur)
	

