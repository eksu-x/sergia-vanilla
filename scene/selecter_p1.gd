extends Sprite


var personnages = []

var CurrentSelected = 0
var CurrentColloneSpot = 0
var CurrentRowSpot	= 0

export (Texture) var P1Text
export (Texture) var P2Text
export (int) var amountOfRows = 2
export (Vector2) var portraitOffset

onready var gridContain = get_parent().get_node("GridContainer")

func _ready():
	psm.player == null
	for nomDuPerso in get_tree().get_nodes_in_group("personnage"):
		personnages.append(nomDuPerso)
		
	texture = P1Text
		
func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		CurrentSelected += 1
		CurrentColloneSpot += 1
		
		if (CurrentColloneSpot > gridContain.columns - 1 && CurrentSelected < personnages.size() - 1):
			position.x -= (CurrentColloneSpot - 1) * portraitOffset.x
			#position.y += portraitOffset.y 
			
			CurrentColloneSpot = 0
			CurrentRowSpot += 1
		elif (CurrentColloneSpot > gridContain.columns - 1 && CurrentSelected > personnages.size() - 1):
			position.x -= (CurrentColloneSpot - 1) * portraitOffset.x
			#position.y -= CurrentRowSpot * portraitOffset.y
			
			CurrentColloneSpot = 0
			CurrentRowSpot = 0
			CurrentSelected = 0
			
		else:
			position.x += portraitOffset.x
		
	elif Input.is_action_just_pressed("ui_left"):
		CurrentSelected -= 1
		CurrentColloneSpot -= 1
		
		if (CurrentColloneSpot < 0 && CurrentSelected > 0):
			position.x += (gridContain.columns - 1) * portraitOffset.x
			#position.y -= (amountOfRows - 1) * portraitOffset.y
			
			CurrentColloneSpot = gridContain.columns - 1
			CurrentRowSpot -= 1
			
		elif (CurrentColloneSpot < 0 && CurrentSelected < 0):
			position.x += (gridContain.columns -1) * portraitOffset.x
			#position.y += (amountOfRows - 1) * portraitOffset.y 
			
			
			CurrentColloneSpot = gridContain.columns - 1
			CurrentRowSpot = amountOfRows - 1
			CurrentSelected = personnages.size() - 1
		else:
			position.x -= portraitOffset.x


	if (Input.is_action_just_pressed("ui_accept")):
		#print(personnages[CurrentSelected].name)
		if(psm.player == null):
			psm.player = psm.selectablePersonnage[personnages[CurrentSelected].name]
			texture = P2Text
		else:
			psm.opponent = psm.selectablePersonnage[personnages[CurrentSelected].name]
			get_tree().change_scene("res://scene/scene01.tscn")
			self.queue_free()
	
	
