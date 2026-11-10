extends KinematicBody2D

# Constante de la vitesse du personnage
const SPEED = 800

# Vecteur de vitesse du projectile
var vel = Vector2()
signal on_hit_by_projectile
# Fonction de démarrage du projectile
var enemy 
onready var OP1 = get_node("../Player1")
onready var OP2 = get_node("../Player2")
var controller_index = 0

func start(pos, dir):
	# Positionner le projectile à la position de départ
	position = pos
	
	# Remplir le vecteur de vitesse avec la vitesse du personnage et la direction
# Fonction de mise à jour du projectile
func _physics_process(delta):
	if controller_index == 0:
		var direction = (OP2.position - position).normalized()
		vel = direction * SPEED
	# Déplacer le projectile en utilisant son vecteur de vitesse
		var collision = move_and_collide(vel * delta)
		if collision:
		# demande si le collider a une methode appelee hit_by_red
			if collision.collider.has_method("tete_hit"):
				collision.collider.tete_hit(0)
			print(collision)
			self.queue_free()	
	elif controller_index == 1:
		var direction = (OP1.position - position).normalized()
		vel = direction * SPEED
	# Déplacer le projectile en utilisant son vecteur de vitesse
		var collision = move_and_collide(vel * delta)
		if collision:
		# demande si le collider a une methode appelee hit_by_red
			if collision.collider.has_method("tete_hit"):
				collision.collider.tete_hit(0)
			print(collision)
			self.queue_free()	
		
func verif_player(input_numb):
	controller_index = input_numb

func _ready():
	if controller_index == 0:
		self.set_collision_layer_bit(5, true)
		self.set_collision_mask_bit(0, true)
		self.set_collision_mask_bit(2, true)
		self.set_collision_mask_bit(8, true)
	elif controller_index == 1:
		self.set_collision_layer_bit(4, true)
		self.set_collision_mask_bit(0, true)
		self.set_collision_mask_bit(1, true)
		self.set_collision_mask_bit(7, true)
