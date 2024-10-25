extends Node

@onready var load_file_dialog = $LoadButton/LoadFileDialog
@onready var save_file_dialog = $SaveButton/SaveFileDialog
@onready var wall_dialog = $"../WallDialog"


func _on_load_button_pressed() -> void:
	load_file_dialog.add_filter('*.json', 'Factory Game Level')
	load_file_dialog.show()


func _on_load_file_dialog_file_selected(path: String) -> void:
	get_tree().paused = false
	print(path)


func _on_save_button_pressed() -> void:
	save_file_dialog.add_filter('*.json', 'Factory Game Level')
	save_file_dialog.show()


func _on_save_file_dialog_file_selected(path: String) -> void:
	get_tree().paused = false
	print(path)


func _on_new_wall_button_pressed() -> void:
	wall_dialog.show()
