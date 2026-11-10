extends KinematicBody2D

var speed = 1000
var vel = Vector2()

func start(pos, dir):
	position = pos
	vel = Vector2(speed * dir, 0)

func _physics_process(delta):
	# Déplacement du projectile
	var collision = move_and_collide(Vector2(speed * delta, 0))
	

	if collision:
		self.queue_free()
		
	

func _ready():
	# Récupération de l'objet "blue" à partir de la scène chargée
	pass
