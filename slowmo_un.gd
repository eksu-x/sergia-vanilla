extends Node

var slow_active: bool = false

export(float) var normal_time: float = 1.0
export(float) var slow_time: float = 0

func start_slowmo():
	Engine.time_scale = 0
	
func end_slowmo():
	Engine.time_scale = normal_time

func request_slow_change():
	if !slow_active:
		start_slowmo()
	else:
		end_slowmo()
