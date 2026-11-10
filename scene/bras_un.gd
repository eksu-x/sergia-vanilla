extends Sprite


func _physics_process(delta):
	var joy_look = Vector2(0, 0)
	
	joy_look.x = Input.get_action_strength("r_right_un") - Input.get_action_strength("r_left_un")
	joy_look.y = Input.get_action_strength("r_down_un") - Input.get_action_strength("r_up_un")
	
	#var ligne_bulet = joy_look - $bras/pos_r.global_position
	#var rota = ligne_bulet.angle()
	look_at(position + joy_look)
