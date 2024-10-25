extends Node2D


@onready var wall_drawer = $WallDrawer
@onready var wall_container_box = $WallsPanel/WallContainerBox

# Whether the user is creating a new wall, or modifying an existing one
enum WallEditType {
	NEW,
	MODIFY
}


# Array[WallData]
var all_wall_data: Array = []

var wall_edit_type: WallEditType
var wall_modify_index: int


func _on_wall_dialog_confirmed(wall_data: WallData) -> void:
	if wall_edit_type == WallEditType.NEW:
		wall_data.index = len(all_wall_data)
		all_wall_data.append(wall_data)
		wall_drawer.update()
		wall_container_box.update()
		
	else:  # Modify
		wall_data.index = wall_modify_index
		all_wall_data[wall_modify_index] = wall_data
		wall_drawer.update()
		wall_container_box.update()
	print(all_wall_data)
