extends KinematicBody2D

const UP = Vector2(0, -1)
var GRAVITY = 30
# déclarez une constante "GRAVITY_DELAY" qui stockera la durée du timer
export var BURST_DELAY = 0

var SHOOT_DELAY = 0.5 # temps en secondes entre chaque tir
var SPEED = 450
var dir = Vector2()
var tire = preload("res://scene/projectile_b.tscn")
var shield = preload("res://scene/shield_y.tscn")
var direction = 1
# ajoutez une variable "inverse_gravity" qui stockera l'état de la gravité
var inverse_gravity = false
var burst_timer = 0
var shoot_delay_timer = 0
var time_shield_last = 0
var SHIELD_DELAY = 0
#TIMER
var time_since_last_shoot = 0 # temps en secondes depuis le dernier tir

#INPUT PLAYER
var input = 0
var joy_pos
var timer = 0
var DELAY = 0.2
var rota
var ready = false
var life = 10

#RECUPERER NODE 
onready var Player1 = get_node("../Player1")
onready var Player2 = get_node("../Player2")

#PRECHARGER SCENE 
export var controller_index = 0

func start(pos, dir):
	# Positionner le projectile à la position de départ
	global_position = pos
#	if controller_index == 0:
##		$AnimationPlayer.play("preload")
#	elif controller_index == 1:
#		$AnimationPlayer.play("preload2")
	
func _ready():
	$life.value = life
	
	if controller_index == 0:
#		self.set_collision_layer_bit(1, true)
		self.set_collision_mask_bit(0, true)
		self.set_collision_layer_bit(1, true)
	if controller_index == 1:
#		self.set_collision_layer_bit(2, true)
		self.set_collision_mask_bit(0, true)
		self.set_collision_layer_bit(2, true)
	pass 

func _physics_process(delta):
#	$hud/life_bar.value = life
	time_since_last_shoot += delta
	burst_timer += delta
	shoot_delay_timer += delta
	timer += delta
	time_shield_last += delta
	
	if inverse_gravity:
		dir.y -= GRAVITY
		$Sprite.flip_v = true
		$CollisionShape2D.position.y = -8
	else:
		dir.y += GRAVITY
		$Sprite.flip_v = false
		$CollisionShape2D.position.y = 8
	
	if life >= 100:
		life = 100
		
	
	moov_p2()
	fire()
	dead()
	dir = move_and_slide(dir, UP)
	
	if Input.is_action_just_pressed("full" + str(controller_index)) and burst_timer >= BURST_DELAY:
			BURST_DELAY = 10
			shoot_delay_timer = 0
			burst_timer = 0
	# mettez la valeur de SHOOT_DELAY à 0
			SHOOT_DELAY = 0.03
	# réinitialisez le compteur de temps
	
	if shoot_delay_timer > 1:
		SHOOT_DELAY = 0.5
		
	if Input.is_action_pressed("shield" + str(controller_index)) and time_shield_last >= SHIELD_DELAY:
		SHIELD_DELAY = 8
		time_shield_last = 0
		var s = shield.instance()
		s.set_playerindex(controller_index)
		s.start(self.global_position, direction)
		get_parent().add_child(s)
	
	
func grav_change(new_grav):
	inverse_gravity = new_grav
	
		
func moov_p2():
	if controller_index == 0:
		joy_pos = Player2.global_position
		$bras_pet.look_at(Player2.global_position)
	elif controller_index == 1:
		joy_pos = Player1.global_position
		$bras_pet.look_at(Player1.global_position)
		#lerp(Input.get_joy_axis(1, 2), 0, 0.1)
	#lerp(Input.get_joy_axis(1, 3), 0, 0.1)
	var ligne_bulet = joy_pos - $bras_pet/pos_b.global_position
	rota = ligne_bulet.angle()
	
	#var smooth_joy = lerp(joy_look, 0, 0.1)
	
	if dir.x > SPEED:
		dir.x = SPEED
	elif dir.x < -SPEED:
		dir.x = -SPEED
		
#		ready = true
	
#	if Input.is_action_pressed("r_right" + str(controller_index)):
#		dir.x = SPEED
#		direction = 1
#	elif Input.is_action_pressed("r_left" + str(controller_index)):
#		dir.x = -SPEED
#		direction = -1
#	else:
#		dir.x = 0
#
#	if Input.is_action_pressed("r_up" + str(controller_index)):
#			dir.y = -SPEED
#	elif Input.is_action_pressed("r_down" + str(controller_index)):
#			dir.y = SPEED
#
#
#
#	if Input.is_action_pressed("right" + str(controller_index)):
#		dir.x = SPEED
#		direction = 1
#		$Sprite.flip_h = false
#		$bras_pet.position.x = -5
#	elif Input.is_action_pressed("left" + str(controller_index)):
#		dir.x = -SPEED
#		direction = -1
#		$Sprite.flip_h = true
#		$bras_pet.position.x = -10
#	else:
#		dir.x = 0
#

func fire():	
	if time_since_last_shoot >= SHOOT_DELAY and ready == true:
		time_since_last_shoot = 0
		var b = tire.instance()
		b.dir_proj(-2300)
		b.verif_player(controller_index)
		b.start($bras_pet/pos_b.global_position, rota)
		get_parent().add_child(b)
	

func grav():
	if inverse_gravity:
		dir.y -= GRAVITY
	else:
		dir.y += GRAVITY
		

func primary_hit(damage, proj_pos):
		life -= damage
		


func verif_player(verif):
	controller_index = verif
	
func dead():
	if life <= 0:
		queue_free()
			
func set_controller(new_controller):
	controller_index = new_controller


func _on_Area2D_body_entered(body):
	if controller_index == 0:
		if body.get_name() == "Player2":
			ready = true
#			$AnimationPlayer.play("ready")
	elif controller_index ==1:
		if body.get_name() == "Player1":
			ready = true
#			$AnimationPlayer.play("ready2")
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if controller_index == 0:
		if body.get_name() == "Player2":
			ready = false
#			$AnimationPlayer.play("preload")
	elif controller_index ==1:
		if body.get_name() == "Player1":
			ready = false
#			$AnimationPlayer.play("preload")
	pass # Replace with function body.
