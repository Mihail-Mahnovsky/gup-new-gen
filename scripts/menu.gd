extends Control

func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/test_polygon.tscn")

func _on_quit_button_down() -> void:
	get_tree().quit()
