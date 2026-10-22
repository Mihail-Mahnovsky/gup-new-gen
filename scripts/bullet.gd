extends Area2D

class_name Bullet

@export var speed: float = 600.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += transform.x * speed * delta
