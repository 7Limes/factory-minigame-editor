extends Node2D


func _on_wall_dialog_confirmed(wall_data: WallData) -> void:
	print(wall_data.type, " ", wall_data.data)
