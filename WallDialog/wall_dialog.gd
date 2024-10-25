extends Window

class_name WallDialog


@onready var motion_type_option = $WindowContainer/DynamicMotionTypeContainer/MotionTypeOption
@onready var oscillate_controls_container = $WindowContainer/OscillateControlsContainer
@onready var rotate_controls_container = $WindowContainer/RotateControlsContainer
@onready var dynamic_checkbox = $WindowContainer/DynamicCheckboxContainer/DynamicCheckBox
@onready var dynamic_motion_type_option = $WindowContainer/DynamicMotionTypeContainer/MotionTypeOption

@onready var segment_x1_entry = $WindowContainer/CoordinateContainer/X1Entry
@onready var segment_y1_entry = $WindowContainer/CoordinateContainer/Y1Entry
@onready var segment_x2_entry = $WindowContainer/CoordinateContainer/X2Entry
@onready var segment_y2_entry = $WindowContainer/CoordinateContainer/Y2Entry

@onready var oscillate_vector_x_entry = $WindowContainer/OscillateControlsContainer/VectorContainer/VectorX
@onready var oscillate_vector_y_entry = $WindowContainer/OscillateControlsContainer/VectorContainer/VectorY
@onready var oscillate_vector_z_entry = $WindowContainer/OscillateControlsContainer/VectorContainer/VectorZ
@onready var oscillate_speed_entry = $WindowContainer/OscillateControlsContainer/SpeedContainer/SpeedEntry
@onready var oscillate_amplitude_entry = $WindowContainer/OscillateControlsContainer/AmplitudeContainer/AmplitudeEntry

@onready var rotate_axis_x_entry = $WindowContainer/RotateControlsContainer/AxisContainer/AxisX
@onready var rotate_axis_y_entry = $WindowContainer/RotateControlsContainer/AxisContainer/AxisY
@onready var rotate_speed_entry = $WindowContainer/RotateControlsContainer/SpeedContainer/SpeedEntry

@onready var error_dialog = $ErrorDialog


var decimal_regex: RegEx;
var DEFAULT_WALL_DATA: WallData


func _ready():
	decimal_regex = RegEx.new()
	decimal_regex.compile('^\\s*[+-]?\\d*\\.?\\d+\\s*$')
	DEFAULT_WALL_DATA = WallData.new()
	DEFAULT_WALL_DATA.type = WallData.WallType.STATIC
	DEFAULT_WALL_DATA.data = [1, 1, 2, 2]


# Emitted when a user presses the Confirm button.
signal confirmed(wall_data: WallData)


func _on_dynamic_check_box_toggled(toggled_on: bool) -> void:
	motion_type_option.disabled = not toggled_on


func _on_motion_type_option_item_selected(index: int) -> void:
	if index == 0:
		oscillate_controls_container.visible = true
		rotate_controls_container.visible = false
	elif index == 1:
		oscillate_controls_container.visible = false
		rotate_controls_container.visible = true


# Shows an error and returns null if the given entry is not a decimal number, otherwise returns float.
# Returns: Union[float, null]
func validate_entry(entry: LineEdit, entry_name: String):
	if decimal_regex.search(entry.text) == null:
		error_dialog.dialog_text = 'Expected a decimal number for %s.' % entry_name
		error_dialog.popup_centered()
		return null
	return clampf(float(entry.text), 0.0, 10.0)


# Returns true if any nulls exist in the array or any nested arrays.
func any_null(arr: Array) -> bool:
	for e in arr:
		if e is Array:
			if any_null(e):
				return true
		elif e == null:
			return true
	return false


# Returns: Union[Array[float], null]
func get_segment_data():
	var segment_data = [
		validate_entry(segment_x1_entry, "segment x1"),
		validate_entry(segment_y1_entry, "segment y1"),
		validate_entry(segment_x2_entry, "segment x2"),
		validate_entry(segment_y2_entry, "segment y2")
	]
	if any_null(segment_data):
		return null
	return segment_data


func get_oscillate_data():
	var vec = [
		validate_entry(oscillate_vector_x_entry, "oscillate vector x"),
		validate_entry(oscillate_vector_y_entry, "oscillate vector y"),
		validate_entry(oscillate_vector_z_entry, "oscillate vector z"),
	]
	var oscillate_data = [
		vec,
		validate_entry(oscillate_speed_entry, 'oscillate speed'),
		validate_entry(oscillate_amplitude_entry, 'oscillate amplitude')
	]
	if any_null(oscillate_data):
		return null
	return oscillate_data


func get_rotate_data():
	var axis = [
		validate_entry(rotate_axis_x_entry, 'rotate axis'),
		validate_entry(rotate_axis_y_entry, 'rotate axis')
	]
	var rotate_data = [
		axis,
		validate_entry(rotate_speed_entry, 'rotate speed')
	]
	if any_null(rotate_data):
		return null
	return rotate_data


func _on_confirm_button_pressed() -> void:
	var segment_data = get_segment_data()
	if segment_data == null:
		return
	
	var wall_data = WallData.new()
	wall_data.type = WallData.WallType.STATIC
	wall_data.data = segment_data
	
	if dynamic_checkbox.button_pressed:
		var motion_data
		var motion_type = dynamic_motion_type_option.get_selected_id()
		if motion_type == 0:  # Oscillate
			motion_data = get_oscillate_data()
		elif motion_type == 1:  # Rotate
			motion_data = get_rotate_data()
		
		if motion_data == null:
			return
		
		wall_data.type = WallData.WallType.DYNAMIC
		wall_data.data = [motion_type, segment_data] + motion_data
	
	emit_signal('confirmed', wall_data)
	hide()
	

func show_with_data(wall_data: WallData):
	var is_dynamic = wall_data.type == WallData.WallType.DYNAMIC
	var segment = wall_data.data if not is_dynamic else wall_data.data[1]
	segment_x1_entry.text = str(segment[0])
	segment_y1_entry.text = str(segment[1])
	segment_x2_entry.text = str(segment[2])
	segment_y2_entry.text = str(segment[3])
	
	dynamic_checkbox.button_pressed = is_dynamic
	if is_dynamic:
		var motion_type = wall_data.data[0]
		motion_type_option.selected = motion_type
		
		if motion_type == 0:  # Oscillate
			oscillate_controls_container.visible = true
			rotate_controls_container.visible = false
			
			var oscillate_vec = wall_data.data[2]
			oscillate_vector_x_entry.text = str(oscillate_vec[0])
			oscillate_vector_y_entry.text = str(oscillate_vec[1])
			oscillate_vector_z_entry.text = str(oscillate_vec[2])
			
			oscillate_speed_entry.text = str(wall_data.data[3])
			oscillate_amplitude_entry.text = str(wall_data.data[4])
		
		elif motion_type == 1:  # Rotate
			oscillate_controls_container.visible = false
			rotate_controls_container.visible = true
			
			var rotate_axis = wall_data.data[2]
			rotate_axis_x_entry.text = str(rotate_axis[0])
			rotate_axis_y_entry.text = str(rotate_axis[1])
			
			rotate_speed_entry.text = str(wall_data.data[3])
	
	else:  # Static
		oscillate_controls_container.visible = false
		rotate_controls_container.visible = false
		motion_type_option.selected = -1
	
	show()


func show_default():
	show_with_data(DEFAULT_WALL_DATA)


func _on_cancel_button_pressed() -> void:
	hide()


func _on_close_requested() -> void:
	hide()
