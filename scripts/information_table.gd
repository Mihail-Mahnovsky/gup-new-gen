extends Control

@onready var speed = $Panel/speed
@onready var amo = $Panel/amo

@export var tank : TankController

func _process(delta: float) -> void:
	if !tank.is_ocupied:
		self.visible = false
		return
	else:
		self.visible = true
	
	var current_speed = round(tank.get_speed_kmh())
	speed.text = "speed : " + str(current_speed) + " km/h"
	amo.text = "amo : " + "No data"
