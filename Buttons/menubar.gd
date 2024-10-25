extends Node

@onready var load_file_dialog = $LoadButton/LoadFileDialog
@onready var save_file_dialog = $SaveButton/SaveFileDialog
@onready var wall_dialog = $"../WallDialog"
@onready var root = $".."


func wall_data_to_dict(all_wall_data: Array) -> Dictionary:
	var dict = {'static': [], 'dynamic': []}
	for wall_data: WallData in all_wall_data:
		if wall_data.type == WallData.WallType.STATIC:
			dict['static'].append(wall_data.data)
		else:  # Dynamic
			dict['dynamic'].append(wall_data.data)
	return dict


func _on_load_button_pressed() -> void:
	load_file_dialog.add_filter('*.json', 'Factory Game Level')
	load_file_dialog.show()


func _on_load_file_dialog_file_selected(path: String) -> void:
	print(path)


func _on_save_button_pressed() -> void:
	save_file_dialog.add_filter('*.json', 'Factory Game Level')
	save_file_dialog.show()


func _on_save_file_dialog_file_selected(path: String) -> void:
	var wall_data_dict = wall_data_to_dict(root.all_wall_data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(wall_data_dict))
	print('Save done!')


func _on_new_wall_button_pressed() -> void:
	root.wall_edit_type = root.WallEditType.NEW
	wall_dialog.show_default()
