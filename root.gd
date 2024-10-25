extends Node2D


# Whether the user is creating a new wall, or modifying an existing one
enum WallEditType {
	NEW,
	MODIFY
}


# Array[WallData]
var all_wall_data: Array = []

var wall_edit_type: WallEditType


func _on_wall_dialog_confirmed(wall_data: WallData) -> void:
	if wall_edit_type == WallEditType.NEW:
		wall_data.index = len(all_wall_data)
		all_wall_data.append(wall_data)
	else:  # Modify
		all_wall_data[wall_data.index] = wall_data
	print(all_wall_data)
