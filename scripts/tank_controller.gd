
extends RigidBody2D

class_name TankController

var is_ocupied: bool = false

@export var engine_force: float = 350.0
@export var torque_force: float = 1.8
@export var linear_damping: float = 0.15
@export var angular_damping: float = 5.0

@export var pixels_per_meter: float = 100.0
@export var max_speed_kmh: float = 55.0
@export var max_reverse_speed_kmh: float = 8.0


@export var braking_force: float = 650.0
@export var turn_acceleration: float = 3.5
@export var turn_speed_factor: float = 0.65
@export var stationary_turn_factor: float = 0.30
@export var lateral_grip: float = 5.0


func get_speed_kmh() -> float:
	var meters_per_second := linear_velocity.length() / maxf(pixels_per_meter, 0.001)
	return meters_per_second * 3.6


func _ready() -> void:
	linear_damp = linear_damping
	angular_damp = angular_damping


func _physics_process(delta: float) -> void:
	if not is_ocupied:
		return

	var scale_factor := pixels_per_meter / 100.0

	var forward_direction := Vector2.RIGHT.rotated(rotation)
	var right_direction := forward_direction.rotated(PI / 2.0)

	var move_input := Input.get_axis("t_back", "t_forward")
	var turn_input := Input.get_axis("t_left", "t_right")

	var max_forward_speed := max_speed_kmh / 3.6 * pixels_per_meter
	var max_reverse_speed := max_reverse_speed_kmh / 3.6 * pixels_per_meter

	var forward_speed := linear_velocity.dot(forward_direction)
	var lateral_speed := linear_velocity.dot(right_direction)

	var target_speed := 0.0

	if move_input > 0.0:
		target_speed = move_input * max_forward_speed
	elif move_input < 0.0:
		target_speed = move_input * max_reverse_speed

	var acceleration := engine_force * scale_factor

	if move_input == 0.0:
		acceleration = braking_force * scale_factor
	elif signf(move_input) != signf(forward_speed) and absf(forward_speed) > 10.0:
		acceleration = braking_force * scale_factor

	forward_speed = move_toward(
		forward_speed,
		target_speed,
		acceleration * delta
	)

	lateral_speed = move_toward(
		lateral_speed,
		0.0,
		lateral_grip * scale_factor * absf(forward_speed) * delta
	)

	linear_velocity = (
		forward_direction * forward_speed
		+ right_direction * lateral_speed
	)


	var speed_ratio := clampf(
		absf(forward_speed) / maxf(max_forward_speed, 1.0),
		0.0,
		1.0
	)

	var turn_factor := lerpf(
		stationary_turn_factor,
		1.0,
		speed_ratio
	)

	var reverse_factor := 1.0
	if forward_speed < -10.0:
		reverse_factor = -1.0

	var target_angular_speed := (
		turn_input
		* torque_force
		* turn_factor
		* reverse_factor
	)

	angular_velocity = move_toward(
		angular_velocity,
		target_angular_speed,
		turn_acceleration * delta
	)
