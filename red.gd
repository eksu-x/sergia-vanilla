extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 30
const FLIP_DELAY = 1
# déclarez une constante "GRAVITY_DELAY" qui stockera la durée du timer
export var GRAVITY_DELAY = 1
export var BURST_DELAY = 0
export var SHIELD_DELAY = 0
export var STOP_DELAY = 0
var SILENCE_DELAY = 0
var LIFE_UP_DELAY = 0
var INVISI_DELAY = 0
var SHOOT_DELAY = 0.5 # temps en secondes entre chaque tir
export var SPEED_DELAY = 10
export var FORCE_JUMP = -750
var HOME_DELAY = 0
var SLOW_DELAY = 0

var anim_machine
var SPEED = 450
var life = 100
var dir = Vector2()
var tire = preload("res://scene/projectile_r.tscn")
var direction = 1
# ajoutez une variable "inverse_gravity" qui stockera l'état de la gravité
var inverse_gravity = false


#TIMER
var time_since_last_shoot = 0 # temps en secondes depuis le dernier tir
var time_shield_last = 0
var stop_timer = 0
var gravity_timer = 0
var shoot_delay_timer = 0
var speed_delay_timer = 0
var burst_timer = 0
var speed_timer = 0
var flip_delay_timer = 0
var stop_delay_timer = 0
var home_delay_timer = 0
var silence_delay_timer = 0
var life_up_timer = 0
var invisi_timer = 0
var slow_timer = 0
var flip_done = false 



#RECUPERER NODE 
onready var burst_i = get_node("burst_img")
onready var speed_i = get_node("speed_img")
onready var grav_i = get_node("grav_img")
onready var shield_i = get_node("shield_img")
onready var win = get_node("../deux_win")
#PRECHARGER SCENE 
var tete = preload("res://scene/tete_r.tscn")
var shield = preload("res://scene/shield_r.tscn")
var call_s = preload("res://scene/stop_un.tscn")
var call_sile = preload("res://scene/silence_un.tscn")
var flip_v = true 

export var controller_index = 0

func _ready():
	anim_machine = $AnimationTree.get("parameters/playback")
	if controller_index == 0:
		self.set_collision_layer_bit(1, true)
		self.set_collision_mask_bit(0, true)
		$hud.offset.x = 60
	if controller_index == 1:
		self.set_collision_layer_bit(2, true)
		self.set_collision_mask_bit(0, true)
		$hud.offset.x = 1600
	pass

func _physics_process(delta):
	
	$hud/life_bar.value = life
	
	if life >= 100:
		life = 100
		
	cooldown()
	moov_p1()
	timer(delta)
	grav()
	call_stop()
	dead()
	call_silence()
	life_up()
	invisible()
	const_anim()
			
		
func moov_p1():
	var joy_look = Vector2(Input.get_joy_axis(controller_index, 2), Input.get_joy_axis(controller_index, 3))
	#var smooth_joy = lerp(joy_look, 0, 0.1)
	var joy_pos = $bras.global_position + joy_look
	var ligne_bulet = joy_pos - $bras/pos_r.global_position
	var rota = ligne_bulet.angle()
	
	if joy_look.length() > 0:
		$bras.look_at($bras.global_position + joy_look.normalized())

		
	if dir.x > SPEED:
		dir.x = SPEED
	elif dir.x < -SPEED:
		dir.x = -SPEED

	if Input.is_action_pressed("right" + str(controller_index)):
		anim_machine.travel("walk")
		dir.x = SPEED
		direction = 1
		shield_i.set_position(Vector2( -80, -8))
		$Sprite.flip_h = false
		$bras.flip_v = false
		$bras.position.x = -8
		$life_up.position.x = 8
	elif Input.is_action_pressed("left" + str(controller_index)):
		anim_machine.travel("walk")
		dir.x = -SPEED
		direction = -1
		shield_i.set_position(Vector2( 80, -8))
		$Sprite.flip_h = true
		$bras.flip_v = true
		$bras.position.x = -6
		$life_up.position.x = -16
	else:
		dir.x = 0
		anim_machine.travel("idle")
	if is_on_floor():
		if Input.is_action_pressed("jump" + str(controller_index)):
			dir.y = FORCE_JUMP
	if is_on_ceiling():
		if Input.is_action_pressed("down" + str(controller_index)):
			dir.y = -FORCE_JUMP
			
	if Input.is_action_pressed("primary" + str(controller_index)) and time_since_last_shoot >= SHOOT_DELAY:
		if SHOOT_DELAY != 0.5:
			anim_machine.travel("burst")
		elif SHOOT_DELAY == 0.5:
			anim_machine.travel("primary")
		time_since_last_shoot = 0
		var b = tire.instance()
		b.verif_player(controller_index)
		b.start($bras/pos_r.global_position, rota)
		get_parent().add_child(b)
		
	if Input.is_action_pressed("slowmo" + str(controller_index)) and slow_timer >= SLOW_DELAY:
		SLOW_DELAY = 20
		slow_timer = 0
		SHOOT_DELAY = 0.0005
		shoot_delay_timer = 0
		Engine.time_scale = 0.01
		var t = Timer.new()
		t.wait_time = 0.025
		t.one_shot = true
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		SHOOT_DELAY = 0.5
		Engine.time_scale = 1
	
	dir = move_and_slide(dir, UP)

		
	# lorsque la touche "grav_r" est appuyée
	if Input.is_action_just_pressed("grav" + str(controller_index)):
		GRAVITY_DELAY = 1
		# si le compteur de temps est supérieur à la durée du timer, réinitialisez-le et inversez l'état de la gravité
		if gravity_timer > GRAVITY_DELAY:
			gravity_timer = 0
			flip_delay_timer = 0
			inverse_gravity = !inverse_gravity
			flip_v = false
			#scale.y = -scale.y
				# sinon, ignorez l'entrée de l'utilisateur
	if flip_delay_timer > 0.4 and flip_v == false:
		scale.y = -scale.y
		flip_v = true 
		
# dans la boucle de mise à jour
	if Input.is_action_just_pressed("full" + str(controller_index)) and burst_timer >= BURST_DELAY:
		burst_timer = 0
		BURST_DELAY = 10
	# mettez la valeur de SHOOT_DELAY à 0
		SHOOT_DELAY = 0.03
	# réinitialisez le compteur de temps
		shoot_delay_timer = 0
		#burst_r_label.set_text(" BURST "+ str(BURST_DELAY - burst_timer) + " ") AFFICHER LE TEMP RESTANT

# si le compteur de temps est supérieur à 2 secondes, remettez la valeur de SHOOT_DELAY à sa valeur initiale
	if Input.is_action_just_pressed("home" + str(controller_index)) and home_delay_timer >= HOME_DELAY:
		tete_chercheuse(tire)
	
	#if Input.is_action_pressed("speed_un"):
		#if speed_timer > SPEED_DELAY:
			#speed_timer = 0
			#SPEED = 1000
			#speed_delay_timer = 0
			#speed_i.visible = false
			
	if Input.is_action_pressed("shield" + str(controller_index)) and time_shield_last >= SHIELD_DELAY:
		SHIELD_DELAY = 7
		shield_i.visible = false
		time_shield_last = 0
		var s = shield.instance()
		s.set_playerindex(controller_index)
		s.start($shield_p.global_position, direction)
		get_parent().add_child(s)
		
	
func cooldown():
	# si le compteur de temps est supérieur à la durée du timer
	if burst_timer >= BURST_DELAY:
		$img/burst_img.visible = true
	elif burst_timer < BURST_DELAY:
		$img/burst_img.visible = false
		
	if time_shield_last >= SHIELD_DELAY:
		$img/shield_img.visible = true
	elif time_shield_last < SHIELD_DELAY:
		$img/shield_img.visible = false
		
	if slow_timer >= SLOW_DELAY:
		$img/slow_img.visible = true
	else:
		$img/slow_img.visible = false
		
	if stop_delay_timer >= STOP_DELAY:
		$img/stop_img.visible = true
	if stop_delay_timer < STOP_DELAY:
		$img/stop_img.visible = false
		
	if home_delay_timer >= HOME_DELAY:
		$img/tete_img.visible = true
	if home_delay_timer < HOME_DELAY:
		$img/tete_img.visible = false
		
	if silence_delay_timer >= SILENCE_DELAY:
		$img/silence_img.visible = true
	if silence_delay_timer < SILENCE_DELAY:
		$img/silence_img.visible = false
	
			
	#reinitialiser le timer du heal a 0 quand on bouge	
	if dir.x > 0:
		life_up_timer = 0
	if dir.x < 0:
		life_up_timer = 0	
	#if life_up_timer > LIFE_UP_DELAY:
		#$life_up.visible = true
	
			
	if shoot_delay_timer > 1:
		SHOOT_DELAY = 0.5
	if stop_delay_timer > 2:
		FORCE_JUMP = -750
		SPEED = 600
	
		
func tete_chercheuse(tire):
	home_delay_timer = 0
	HOME_DELAY = 3
	var tete_b = tete.instance()
	tete_b.verif_player(controller_index)
	tete_b.start($bras/pos_r.global_position, direction)
	get_parent().add_child(tete_b)


func call_stop():
	if Input.is_action_pressed("stop" + str(controller_index)) and stop_delay_timer >= STOP_DELAY:
		STOP_DELAY = 10
		stop_delay_timer = 0
		var call = call_s.instance()
		call.verif_player(controller_index)
		call.start($bras/pos_r.global_position, direction)
		get_parent().add_child(call)   
		
func call_silence():
	if Input.is_action_pressed("silence" + str(controller_index)) and silence_delay_timer >= SILENCE_DELAY:
		SILENCE_DELAY = 7
		silence_delay_timer = 0
		var call = call_sile.instance()
		call.verif_player(controller_index)
		call.start($bras/pos_r.global_position, direction)
		get_parent().add_child(call)
		
func grav():
	if inverse_gravity:
		dir.y -= GRAVITY
	else:
		dir.y += GRAVITY
		
	
func stop_hit(delta):
		speed_delay_timer = 0
		stop_delay_timer = 0
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
		
func invisible():
	if Input.is_action_pressed("invisible" + str(controller_index)) and invisi_timer >= INVISI_DELAY:
		INVISI_DELAY = 10
		invisi_timer = 0
		$invisible.emitting = true
		$img.visible = false
		$Sprite.visible = false
		$bras.visible = false
		$silence.visible = false
		$life_up.visible = false
		var t = Timer.new()
		t.wait_time = 2
		t.one_shot = true
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		$img.visible = true
		$Sprite.visible = true
		$bras.visible = true
		$life_up.visible = true
		Engine.time_scale = 1

		
func silence_hit(GRAVITY_DELAY, BURST_DELAY, LIFE_UP_DELAY):
	gravity_timer = 0
	SHIELD_DELAY = 7
	time_shield_last = 0 #remettre shield a zero
	burst_timer = 0
	life_up_timer = 0
	$silence.visible = true
	$life_up.set_modulate(Color(1,0.3,0.3,1))
	var t = Timer.new()
	t.wait_time = 5
	t.one_shot = true
	add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	LIFE_UP_DELAY = 0
	$silence.visible = false
	$life_up.set_modulate(Color(1,1,1,1))
	set_modulate(Color(1,1,1,1))
	Engine.time_scale = 1
	
func primary_hit(primary_pos, pos_proj):
	life -= 5
	$hud/life_bar.value = life
	
	if position.x < primary_pos:
		dir.x = 1500
	elif position.x > primary_pos:
		dir.x = -1500
		
	if inverse_gravity == false:
		set_modulate(Color(1,0.3,0.3,1))
		var t = Timer.new()
		t.wait_time = 1
		t.one_shot = true
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		set_modulate(Color(1,1,1,1))
		Engine.time_scale = 1
	elif inverse_gravity == true:
		set_modulate(Color(1,0.3,0.3,1))
		var t = Timer.new()
		t.wait_time = 1
		t.one_shot = true
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		set_modulate(Color(1,1,1,1))
		Engine.time_scale = 1

func tete_hit(idk):
	life -= 15
	$hud/life_bar.value = life
	set_modulate(Color(1,0.3,0.3,1))
	var t = Timer.new()
	t.wait_time = 1
	t.one_shot = true
	add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	set_modulate(Color(1,1,1,1))
	Engine.time_scale = 1

func hand_hit(val):
	print("salut")
	
func life_up():
	
	if Input.is_action_pressed("speed" + str(controller_index)) and dir.x == 0 and life <= 80:
		$life_up.emitting = true
		if life_up_timer > LIFE_UP_DELAY:
			LIFE_UP_DELAY = 1
			life_up_timer = 0
			life += 5
			$hud/life_bar.value = life
	else:
		$life_up.emitting = false

func const_anim():
	$anim.play("burst_cool")
		
func timer(delta):
	# incrémentez le compteur de temps
	shoot_delay_timer += delta
	speed_delay_timer += delta
	burst_timer += delta
	gravity_timer += delta
	speed_timer += delta 
	flip_delay_timer += delta
	stop_timer += delta
	time_since_last_shoot += delta
	time_shield_last += delta
	stop_delay_timer += delta
	home_delay_timer += delta
	silence_delay_timer += delta
	life_up_timer += delta
	invisi_timer += delta
	slow_timer += delta

func dead():
	if life <= 0:
		win.visible = true
		print("Blue Win")
		self.visible = false 
		Engine.time_scale = 0
			
func set_controller(new_controller):
	controller_index = new_controller
#	if controller_index == 0:
#		$hud/life_bar.rect_position.x = 16
#		$hud/life_bar.rect_position.x = -88
#	if controller_index == 1:	
#		$hud/life_bar.rect_position.x = 1668
#		$hud/life_bar.rect_position.x = -88
