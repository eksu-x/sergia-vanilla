extends KinematicBody2D


var velocity = Vector2()
var speed = 400
var gravity = Vector2(0, -908)



func _physics_process(delta):
	
	global velocity
	
	velocity -= gravity * delta
	# Réinitialisation de la vitesse de déplacement horizontale à 0
	velocity.x = 0
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -700

	move_and_slide(velocity)

func _ready():
	pass 

