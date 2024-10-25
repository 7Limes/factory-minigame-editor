extends Node

@onready var root = $".."
@onready var load_file_dialog = $LoadButton/LoadFileDialog
@onready var save_file_dialog = $SaveButton/SaveFileDialog
@onready var wall_dialog = $"../WallDialog"
@onready var message_dialog = $"../MessageDialog"


func show_message(title: String, message: String):
	message_dialog.title = title
	message_dialog.dialog_text = message
	message_dialog.popup_centered()


func wall_data_to_dict(all_wall_data: Array) -> Dictionary:
	var dict = {'static': [], 'dynamic': []}
	for wall_data: WallData in all_wall_data:
		if wall_data.type == WallData.WallType.STATIC:
			dict['static'].append(wall_data.data)
		else:  # Dynamic
			dict['dynamic'].append(wall_data.data)
	return dict


# Returns: Array[WallData]
func dict_to_wall_data(level_dict: Dictionary) -> Array:
	var all_wall_data: Array = []
	for wall_data_array in level_dict['static']:
		var wall_data = WallData.new()
		wall_data.type = WallData.WallType.STATIC
		wall_data.data = wall_data_array
		wall_data.index = len(all_wall_data)
		all_wall_data.append(wall_data)
	for wall_data_array in level_dict['dynamic']:
		var wall_data = WallData.new()
		wall_data.type = WallData.WallType.DYNAMIC
		wall_data.data = wall_data_array
		wall_data.index = len(all_wall_data)
		all_wall_data.append(wall_data)
	return all_wall_data


func _on_load_button_pressed() -> void:
	load_file_dialog.add_filter('*.json', 'Factory Game Level')
	load_file_dialog.show()


func _on_load_file_dialog_file_selected(path: String) -> void:
	var level_dict = JSON.parse_string(FileAccess.get_file_as_string(path))
	root.all_wall_data = dict_to_wall_data(level_dict)
	root.update_walls()
	


func _on_save_button_pressed() -> void:
	if not root.all_wall_data:
		show_message('Error', 'Place some walls down first.')
		return
	save_file_dialog.add_filter('*.json', 'Factory Game Level')
	save_file_dialog.show()


func _on_save_file_dialog_file_selected(path: String) -> void:
	var wall_data_dict = wall_data_to_dict(root.all_wall_data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(wall_data_dict))
	show_message('Saved', 'Level saved successfully!')


func _on_new_wall_button_pressed() -> void:
	root.wall_edit_type = root.WallEditType.NEW
	wall_dialog.show_default()
