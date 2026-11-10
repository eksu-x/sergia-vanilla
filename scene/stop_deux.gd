extends KinematicBody2D

const UP = Vector2(0, -1)
const ACCEL = 50
const FLIP_DELAY = 1

var SPEED = 600
var life = 100
var dir = Vector2()
var direction = 1
var timer = 0
var DELAY = 0.2
onready var Player1 = get_node("../Player1")
onready var Player2 = get_node("../Player2")
var life_time = 0
export var controller_index = 1

func start(pos, dir):
	position = pos
	life_time = 0

func _physics_process(delta):    
	timer += delta              
	life_time += delta
	# limiter la vitesse de déplacement de votre personnage
	if dir.x > SPEED:
		dir.x = SPEED
	elif dir.x < -SPEED:
		dir.x = -SPEED
	moov_trans_j1()
	# Déplacer le projectile en utilisant son vecteur de vitesse
	var collision = move_and_collide(dir * delta)

	dir = move_and_slide(dir, UP)
	#separate()
#	if collision:
#		# demande si le collider a une methode appelee hit_by_red
#		if collision.collider.has_method("stop_hit"):
#			collision.collider.stop_hit(delta)
#		print(collision)
#		self.queue_free()	
	if life_time > 3:
		queue_free()
		
func moov_trans_j1():
	if Input.is_action_pressed("r_right" + str(controller_index)):
		dir.x = SPEED
		direction = 1
	elif Input.is_action_pressed("r_left" + str(controller_index)):
		dir.x = -SPEED
		direction = -1
	else:
		dir.x = 0
		
	if Input.is_action_pressed("r_up" + str(controller_index)):
			dir.y = -SPEED
	elif Input.is_action_pressed("r_down" + str(controller_index)):
			dir.y = SPEED
	else:
		dir.y = 0
	
	if Input.is_action_just_pressed("stop"+ str(controller_index)) and timer > DELAY:
		if controller_index == 0:
			Player1.position = self.position
		if controller_index == 1:
			Player2.position = self.position
		queue_free()
			
func verif_player(input_numb):
	controller_index = input_numb

func _ready():
	if controller_index == 0:
		self.set_collision_layer_bit(12, true)#je suis
	#je touche
		self.set_collision_mask_bit(0, true)
	elif controller_index == 1:
		self.set_collision_layer_bit(13, true)
	
		self.set_collision_mask_bit(0, true)
	pass


			
