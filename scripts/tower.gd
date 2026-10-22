extends Node2D

@export var rot_speed : float = 7
@export var tank : TankController

func _process(delta: float) -> void:
	if tank.is_ocupied:
		var mouse_pos = get_global_mouse_position()
		var target_angle = global_position.angle_to_point(mouse_pos)
		global_rotation = rotate_toward(global_rotation, target_angle, rot_speed * delta)
