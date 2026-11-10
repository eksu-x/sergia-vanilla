extends KinematicBody2D

const UP = Vector2(0, -1)
const ACCEL = 50
const GRAVITY = 20
const FLIP_DELAY = 1
# déclarez une constante "GRAVITY_DELAY" qui stockera la durée du timer
var GRAVITY_DELAY = 10
var BURST_DELAY = 30
var SPEED_DELAY = 10
var FORCE_JUMP = -750

var angle = 0

var SPEED = 200
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
var speed_delay_timer = 0
var burst_timer = 0
var speed_timer = 0
var flip_delay_timer = 0
var stop_timer = 0
var flip_done = false 
onready var burst_i = get_node("burst_img")
onready var speed_i = get_node("speed_img")
onready var grav_i = get_node("grav_img")
onready var enemy = get_node("../blue")
# Constantes pour la touche "burst"
const CIRCLE_DELAY = 30 # durée du timer avant de pouvoir utiliser la touche "burst" à nouveau
const CIRCLE_ANGLE_DELTA = 15 # intervalle d'angle entre chaque projectile
const CIRCLE_NUM_PROJECTILES = 4 # nombre de projectiles à tirer

# Ajoutez une variable "burst_timer" qui servira de compteur de temps
var circle_timer_timer = 0
var CIRCLE_DIST = 0
var flip_v = true 





func _physics_process(delta):
	
	timer(delta)
	moov_p1()
	# si le compteur de temps est supérieur à la durée du timer
	if gravity_timer > GRAVITY_DELAY:
	# affichez le message
			grav_i.visible = true
# sinon, si le compteur de temps est inférieur à la durée du timer
		
	if burst_timer > BURST_DELAY:
			burst_i.visible = true
			
	if speed_timer > SPEED_DELAY:
			speed_i.visible = true

	if inverse_gravity:
		dir.y -= GRAVITY
	else:
		dir.y += GRAVITY
		
	time_since_last_shoot += delta
	if Input.is_action_pressed("fire") and time_since_last_shoot >= SHOOT_DELAY:
		time_since_last_shoot = 0
		var b = tire.instance()
		b.start($pos_r.global_position, direction)
		get_parent().add_child(b)
		
	# lorsque la touche "grav_r" est appuyée
	if Input.is_action_just_pressed("grav_r"):
		# si le compteur de temps est supérieur à la durée du timer, réinitialisez-le et inversez l'état de la gravité
		if gravity_timer > GRAVITY_DELAY:
			gravity_timer = 0
			flip_delay_timer = 0
			inverse_gravity = !inverse_gravity
			grav_i.visible = false
			flip_v = false
			#scale.y = -scale.y
				# sinon, ignorez l'entrée de l'utilisateur
	if flip_delay_timer > 0.4 and flip_v == false:
		scale.y = -scale.y
		flip_v = true 
		
# dans la boucle de mise à jour
	if Input.is_action_just_pressed("E"):
		if burst_timer > BURST_DELAY:
			burst_timer = 0
	# mettez la valeur de SHOOT_DELAY à 0
			SHOOT_DELAY = 0
	# réinitialisez le compteur de temps
			shoot_delay_timer = 0
			burst_i.visible = false
		#else:
			#burst_r_label.set_text(" BURST "+ str(BURST_DELAY - burst_timer) + " ") AFFICHER LE TEMP RESTANT

# si le compteur de temps est supérieur à 2 secondes, remettez la valeur de SHOOT_DELAY à sa valeur initiale
	if shoot_delay_timer > 1:
		SHOOT_DELAY = 0.5
	
	
	if Input.is_action_pressed("F"):
		if speed_timer > SPEED_DELAY:
			speed_timer = 0
			SPEED = 1000
			speed_delay_timer = 0
			speed_i.visible = false
			
			
	if speed_delay_timer > 3:
		SPEED = 200
func moov_p1():
	if dir.x > SPEED:
		dir.x = SPEED
	elif dir.x < -SPEED:
		dir.x = -SPEED

	if Input.is_action_pressed("D"):
		dir.x = SPEED
		direction = 1
		$pos_r.position.x = 73
		$Sprite.flip_h = false
	elif Input.is_action_pressed("A"):
		dir.x = -SPEED
		direction = -1
		$pos_r.position.x = -50
		$Sprite.flip_h = true
	else:
		dir.x = 0
	if is_on_floor():
		if Input.is_action_pressed("W"):
			dir.y = FORCE_JUMP
	if is_on_ceiling():
		if Input.is_action_pressed("S"):
			dir.y = -FORCE_JUMP
			
	dir = move_and_slide(dir, UP)
	
func hit_by_blue(damage):
	set_modulate(Color(1,0.3,0.3,1))
	dir.y = FORCE_JUMP * 0.5
	var t = Timer.new()
	t.wait_time = 1
	t.one_shot = true
	add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	set_modulate(Color(1,1,1,1))
	Engine.time_scale = 1
	
	life -= damage
	if life <= 0:
		print("Blue Win")
		queue_free()
		
func stop_hit(delta):
		stop_timer = 0
		set_modulate(Color(0,0.3,1.3,1))
		SPEED = 0
		FORCE_JUMP = 0
		var t = Timer.new()
		t.wait_time = 2
		t.one_shot = true
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		set_modulate(Color(1,1,1,1))
		Engine.time_scale = 1
		print("silence")

func timer(delta):
# incrémentez le compteur de temps
	shoot_delay_timer += delta
	speed_delay_timer += delta
	burst_timer += delta
	gravity_timer += delta
	speed_timer += delta 
	flip_delay_timer += delta
	time_since_last_shoot += delta
	
func _ready():
	pass 



			
