extends KinematicBody2D

# Constante de la vitesse du personnage
export var SPEED = 2300

# Vecteur de vitesse du projectile
var vel = Vector2()
var controller_index = 0

signal on_hit_by_projectile
# Fonction de démarrage du projectile

func start(pos, dir):
	# Positionner le projectile à la position de départ
	position = pos
	rotation = dir
	
	# Remplir le vecteur de vitesse avec la vitesse du personnage et la direction
	vel = Vector2(-SPEED,0).rotated(rotation)
# Fonction de mise à jour du projectile
func _physics_process(delta):
	# Déplacer le projectile en utilisant son vecteur de vitesse
	var collision = move_and_collide(vel * delta)
	if collision:
		# demande si le collider a une methode appelee hit_by_red
		if collision.collider.has_method("primary_hit"):
			collision.collider.primary_hit(5, position.x)
		self.queue_free()	
	
		
func verif_player(input_numb):
	controller_index = input_numb

func _ready():
	$AnimationPlayer.play("primary_ready")
	if controller_index == 0:
		self.set_collision_layer_bit(3, true)
		self.set_collision_mask_bit(0, true)
		self.set_collision_mask_bit(2, true)
		self.set_collision_mask_bit(4, true)
		self.set_collision_mask_bit(8, true)
	elif controller_index == 1:
		self.set_collision_layer_bit(4, true)
		self.set_collision_mask_bit(0, true)
		self.set_collision_mask_bit(1, true)
		self.set_collision_mask_bit(3, true)
		self.set_collision_mask_bit(7, true)
	# Récupération de l'objet "blue" à partir de la scène chargée
	pass
