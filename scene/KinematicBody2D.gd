extends KinematicBody2D

# Création de variables pour stocker la vitesse de déplacement et la vitesse de déplacement lorsqu'on se déplace à droite ou à gauche
var velocity = Vector2()
var speed = 400
var gravity = Vector2(0, -908)

var projectile_speed = 500
var fire_rate = 0.2
var time_since_last_fire = 0


# Fonction qui est exécutée à chaque frame
func _physics_process(delta):
	
	velocity -= gravity * delta
	# Réinitialisation de la vitesse de déplacement horizontale à 0
	velocity.x = 0
	
	if Input.is_action_pressed("fire"):
		time_since_last_fire += delta
	if time_since_last_fire >= fire_rate:
		time_since_last_fire = 0

		# Créez un nouveau projectile et définissez sa position et sa vitesse
		var projectile = preload("path/to/pro").instance()
		projectile.position = self.position
		projectile.movement = self.movement.normalized() * projectile_speed

	# Si la touche de déplacement à droite est enfoncée, ajout de la vitesse de déplacement à droite à la vitesse de déplacement horizontale
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	# Si la touche de déplacement à gauche est enfoncée, retrait de la vitesse de déplacement à gauche de la vitesse de déplacement horizontale
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

	# Déplacement du personnage en tenant compte de la physique du moteur de jeu
	move_and_slide(velocity)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
