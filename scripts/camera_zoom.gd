extends Camera2D

@export var tank : TankController

@export var min_zoom: float = 1.0  
@export var max_zoom: float = 0.6  
@export var zoom_speed: float = 2.0 

func _process(delta: float) -> void:
	if not tank:
		return
		
	var speed_factor = tank.get_speed_kmh() / tank.max_speed_kmh
	speed_factor = clamp(speed_factor, 0.0, 1.0)
	
	var target_zoom_value = lerp(min_zoom, max_zoom, speed_factor)
	var target_zoom = Vector2(target_zoom_value, target_zoom_value)
	
	self.zoom = self.zoom.lerp(target_zoom, zoom_speed * delta)
