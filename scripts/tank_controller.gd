extends RigidBody2D

class_name TankController

var is_ocupied: bool = false 

@export var engine_force: float = 15000.0   
@export var torque_force: float = 25000.0 
@export var linear_damping: float = 3.0  
@export var angular_damping: float = 5.0 

@export var pixels_per_meter: float = 2048.0  
@export var max_speed_kmh: float = 41.0     

func get_speed_kmh() -> float:
	var meters_per_second = linear_velocity.length() / pixels_per_meter
	return meters_per_second * 3.6

func _ready() -> void:
	linear_damp = linear_damping
	angular_damp = angular_damping

func _physics_process(_delta: float) -> void:
	if not is_ocupied:
		return

	var turn_input := Input.get_axis("t_left", "t_right")
	if turn_input != 0:
		apply_torque(turn_input * torque_force)
	else:
		angular_velocity = 0.0

	var move_input := Input.get_axis("t_back", "t_forward")
	var forward_direction := Vector2.RIGHT.rotated(rotation)
	
	apply_central_force(forward_direction * move_input * engine_force)

	var max_speed_px_s = (max_speed_kmh / 3.6) * pixels_per_meter
	if linear_velocity.length() > max_speed_px_s:
		linear_velocity = linear_velocity.limit_length(max_speed_px_s)
