extends KinematicBody2D

# Constante de la vitesse du personnage
const SPEED = 0

# Vecteur de vitesse du projectile
var vel = Vector2()
onready var P1 = get_node("../Player1")
onready var P2 = get_node("../Player2")
signal on_hit_by_projectile
var temps_vie = 0
var VIE_DELAY = 2
var controller_index = 0
# Fonction de démarrage du projectile

func start(pos, dir):
	temps_vie = 0
	
	# Positionner le projectile à la position de départ

	position = pos
	
	# Remplir le vecteur de vitesse avec la vitesse du personnage et la direction
	vel = Vector2(SPEED * dir, 0)
# Fonction de mise à jour du projectile
func _physics_process(delta):
	
	if controller_index == 0:
		temps_vie += delta
		position = P1.position
		if temps_vie >= VIE_DELAY:
			queue_free()
	else:
		temps_vie += delta
		position = P2.position
		if temps_vie >= VIE_DELAY:
			queue_free()
		
		
func _ready():
	if controller_index == 0:
		self.set_collision_layer_bit(7, true)#je suis
		#je touche
		self.set_collision_mask_bit(4, true)
		self.set_collision_mask_bit(6, true)
		self.set_collision_mask_bit(11, true)
		self.set_collision_mask_bit(13, false)
	elif controller_index == 1:
		self.set_collision_layer_bit(8, true)
		
		self.set_collision_mask_bit(3, true)
		self.set_collision_mask_bit(5, true)
		self.set_collision_mask_bit(9, true)
		self.set_collision_mask_bit(12, false)	
	pass
	
func set_playerindex(new_index):
		controller_index = new_index
