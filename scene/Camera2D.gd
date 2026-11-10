extends Node2D


#onready var player_un = get_node("../red")
#onready var player_deux = get_node("../blue")

var tracking_speed = 10

var MIN_DIST = 200
var MAX_DIST = 1700
var zoom_pos = 1.0
const MIN_ZOOM = 0.7
const MAX_ZOOM = 1.6
const ZOOM_INC = 1.0
const ZOOM_RATE = 8.0
var ZOOM = Vector2()
var call_player1 = 0
var call_player2 = 1
var test = 0
var test2 = 0
var timer = 0
var DELAY = 2
var P1
var P2

func _ready():
	#set_process(false)
	P1 = get_node("/root/scene01/Player1")
	P2 = get_node("/root/scene01/Player2")
	
	print("CAMARCHECAMAMAN")
	

func _process(delta):
#	if call_player1 == 0 and call_player1 == 1:
	#if player_un.position.x > 0 and player_deux.position.x > 0 :
		var center_pos = (P1.position + P2.position) / 2
	
		var distance = P1.position.distance_to(P2.position)
	
	#var zoom = clamp(distance, MAX_ZOOM, MIN_ZOOM) / MAX_ZOOM
	
		var distance2 = $Camera2D.position.distance_to(center_pos)
		
		var speed = distance2 * tracking_speed
	
		var t = (distance - MIN_DIST) / (MAX_DIST - MIN_DIST)
	
		t = clamp(t, 0, 1)
	
		ZOOM.x = lerp(MIN_ZOOM, MAX_ZOOM, t)
	
		ZOOM.y = ZOOM.x
	
	#if distance < 200:
		#ZOOM.x = 0.5
		#ZOOM.y = 0.5
	#if distance > 200:
		#ZOOM.x = 1.0
		#ZOOM.y = 1.0
	
	
		$Camera2D.zoom = ZOOM
	
		$Camera2D.position = $Camera2D.position.move_toward(center_pos, speed * delta)
	
	
func control(call1, call2):
	test = call1
	test2 = call2
#	call_player1 = call1
#	call_player2 = call2

	
	
