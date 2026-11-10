extends KinematicBody2D

const UP = Vector2(0, -1)
const ACCEL = 50
const SPEED = 500
const FORCE_JUMP = -700
const GRAVITY = 20
# déclarez une constante "GRAVITY_DELAY" qui stockera la durée du timer
var GRAVITY_DELAY = 10

var SHOOT_DELAY = 0.5 # temps en secondes entre chaque tir
var life = 100
var dir = Vector2()
var tire = preload("res://scene/projectile_r.tscn")
var direction = 1
var time_since_last_shoot = 0 # temps en secondes depuis le dernier tir
var input_enabled = true
# ajoutez une variable "inverse_gravity" qui stockera l'état de la gravité
var inverse_gravity = false
# ajoutez une variable "gravity_timer" qui servira de compteur de temps
var gravity_timer = 0
var shoot_delay_timer = 0
onready var grav_r_label = get_node("../map/grav_rouge")





func _physics_process(delta):
	# si la gravité est inversée, utilisez une valeur négative pour la gravité
	# sinon, utilisez la valeur positive
	if inverse_gravity:
		dir.y -= GRAVITY
	else:
		dir.y += GRAVITY
		
	# limiter la vitesse de déplacement de votre personnage
	if dir.x > SPEED:
		dir.x = SPEED
	elif dir.x < -SPEED:
		dir.x = -SPEED


	if Input.is_action_pressed("D"):
		dir.x = SPEED
		direction = 1
		$pos_r.position.x = 28
	elif Input.is_action_pressed("A"):
		dir.x = -SPEED
		direction = -1
		$pos_r.position.x = -28
	else:
		dir.x = 0
	if is_on_floor():
		if Input.is_action_pressed("W"):
			dir.y = FORCE_JUMP
	if is_on_ceiling():
		if Input.is_action_pressed("S"):
			dir.y = -FORCE_JUMP
			
	# gérer le temps entre chaque tir à l'aide d'un timer
	time_since_last_shoot += delta
	if Input.is_action_pressed("fire") and time_since_last_shoot >= SHOOT_DELAY:
		time_since_last_shoot = 0
		var b = tire.instance()
		b.start($pos_r.global_position, direction)
		get_parent().add_child(b)
		
	# incrémentez le compteur de temps
	gravity_timer += delta
	
	#if Imput.is_action_presse("E")
		
	
	# lorsque la touche "grav_r" est appuyée
	if Input.is_action_just_pressed("grav_r"):
		# si le compteur de temps est supérieur à la durée du timer, réinitialisez-le et inversez l'état de la gravité
		if gravity_timer > GRAVITY_DELAY:
			gravity_timer = 0
			inverse_gravity = !inverse_gravity
		# sinon, ignorez l'entrée de l'utilisateur
		else:
			grav_r_label.set_text(" GRAV "+ str(GRAVITY_DELAY - gravity_timer) + " ")
			

# dans la boucle de mise à jour
	if Input.is_action_just_pressed("E"):
	# mettez la valeur de SHOOT_DELAY à 0
			SHOOT_DELAY = 0
	# réinitialisez le compteur de temps
			shoot_delay_timer = 0

# incrémentez le compteur de temps
	shoot_delay_timer += delta

# si le compteur de temps est supérieur à 2 secondes, remettez la valeur de SHOOT_DELAY à sa valeur initiale
	if shoot_delay_timer > 1:
		SHOOT_DELAY = 0.5
			
		# activer ou désactiver la prise en compte des entrées de l'utilisateur
	set_process_input(input_enabled)
			
	# utiliser la fonction separate() pour gérer les collisions
	dir = move_and_slide(dir, UP)
	#separate()
	
func hit_by_blue(damage):
	life -= damage
	if life <= 0:
		print("Blue Win")
		queue_free()
		
	
func _ready():
	pass 



			
