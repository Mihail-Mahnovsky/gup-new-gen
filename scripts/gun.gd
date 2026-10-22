extends Node2D

@export var OBJECT_SCENE : PackedScene
@export var reload_time = 4
@export var reload_current : float = reload_time

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	
	if reload_current > 0:
		reload_current -= delta
	
	if Input.is_action_just_pressed("shoot") and reload_current <= 0:
		var instance = OBJECT_SCENE.instantiate()
		instance.position = global_position
		instance.rotation = global_rotation
		get_tree().current_scene.add_child(instance)
		reload_current = reload_time
