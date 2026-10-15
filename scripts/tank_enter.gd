extends Area2D

@onready var parent = get_parent() as TankController
var player_inside: Node2D = null

var passenger: Node2D = null

func set_player(val: bool) -> void:
	if passenger: 
		passenger.visible = val
		passenger.set_process(val) 
		passenger.set_physics_process(val)
	
		passenger.get_node("CollisionShape2D").set_deferred("disabled", !val)

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		player_inside = body

func _on_body_exited(body: Node2D):
	if body == player_inside:
		player_inside = null

func _process(_delta: float):
	if player_inside != null and Input.is_action_just_pressed("seat"):
		if parent and not parent.is_ocupied:
			parent.is_ocupied = true
			passenger = player_inside 
			set_player(false)

	if Input.is_action_just_pressed("exit") and passenger != null:
		if parent:
			parent.is_ocupied = false
			passenger.global_position = global_position + Vector2(120, 105)
			set_player(true)
			passenger = null
