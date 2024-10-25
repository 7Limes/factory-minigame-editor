extends Button

@onready var file_dialog = $SaveFileDialog

func _on_pressed() -> void:
	file_dialog.add_filter('*.json', 'Factory Game Level')
	file_dialog.show()


func _on_save_file_dialog_file_selected(path: String) -> void:
	get_tree().paused = false
	print(path)
