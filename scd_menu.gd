extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var mainmenugamescene : PackedScene
onready var player_un = get_node("../red")
onready var player_deux = get_node("../blue")
onready var apl_scene = load("res://scene/scene01.tscn").instance()
onready var pos_cam = apl_scene.get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	#self.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_vengeance_button_button_up():
	get_tree().reload_current_scene()
	pass # Replace with function body.

#func _physics_process(delta):
	#self.global_position = get_viewport_rect().size/2
	#self.global_position = pos_cam.position
	
	
func _on_menu_button_button_up():
	get_tree().change_scene("res://scene/main_menu.tscn")
	pass # Replace with function body.


func _on_quit_button_button_up(): 
	get_tree().current_scene.quit()
	pass # Replace with function body.


func _on_Continuer_button_button_up():
	get_tree().paused = false 
	queue_free()
	pass # Replace with function body.
