extends KinematicBody2D

const UP = Vector2(0, -1)
const ACCEL = 50
const FLIP_DELAY = 1

var SPEED = 600
var life = 100
var dir = Vector2()
var direction = 1

var life_time = 0
var controller_index = 0

func start(pos, dir):
	position = pos
	life_time = 0

func _physics_process(delta):                  
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
	if collision:
		# demande si le collider a une methode appelee hit_by_red
		if collision.collider.has_method("stop_hit"):
			collision.collider.stop_hit(delta)
		print(collision)
		self.queue_free()	
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
		
func verif_player(input_numb):
	controller_index = input_numb
	
func _ready():
	if controller_index == 0:
		self.set_collision_layer_bit(9, true)#je suis
	
		self.set_collision_mask_bit(2, true)#je touche
		self.set_collision_mask_bit(8, true)
		self.set_collision_mask_bit(11, true)
	elif controller_index == 1:
		self.set_collision_layer_bit(11, true)
	
		self.set_collision_mask_bit(1, true)
		self.set_collision_mask_bit(7, true)
		self.set_collision_mask_bit(9, true)
	pass
