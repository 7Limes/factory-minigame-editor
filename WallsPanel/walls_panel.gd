extends BoxContainer


@onready var root = $"../../.."
@onready var wall_drawer = $"../../../WallDrawer"
@onready var wall_dialog = $"../../../WallDialog"
@onready var panel_node = $"../.."


const WALL_CONTAINER_COLOR = Color(0.15, 0.15, 0.15)
const WALL_CONTAINER_HOVER_COLOR = Color(0.15, 0.15, 0.5)
const LINE_HOVER_COLOR = Color(0.2, 1.0, 0.2)

var saved_line_color: Color = Color(1.0, 1.0, 1.0)


const MOTION_TYPES = [
	'oscillate',
	'rotate'
]


func _process(delta: float) -> void:
	panel_node.size.y = get_viewport_rect().size.y-32


func new_label(text: String) -> Label:
	var label = Label.new()
	label.add_theme_font_size_override('font_size', 14)
	label.text = text
	return label


func set_panel_color(panel: PanelContainer, color: Color):
	var stylebox: StyleBoxFlat = panel.get_theme_stylebox('panel')
	stylebox.bg_color = color


func generate_container(wall_data: WallData, index: int) -> PanelContainer:
	var panel_container = PanelContainer.new()
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = WALL_CONTAINER_COLOR
	panel_container.add_theme_stylebox_override('panel', stylebox)
	
	var parent_container = BoxContainer.new()  # Contains wall container and delete button
	parent_container.custom_minimum_size = Vector2(panel_node.size.x-10, 0)
	
	var container = WallContainer.new()
	container.all_walls_index = index
	container.vertical = true
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_theme_constant_override('separation', -3)
	
	var type_label = new_label('Type: static' if wall_data.type == 0 else 'Type: dynamic')
	container.add_child(type_label)
	
	var segment_label = new_label('')
	
	if wall_data.type == WallData.WallType.STATIC:
		segment_label.text = 'Segment: %s' % str(wall_data.data)
		container.add_child(segment_label)
	elif wall_data.type == WallData.WallType.DYNAMIC:
		segment_label.text = 'Segment: %s' % str(wall_data.data[1])
		container.add_child(segment_label)
		
		var motion_type = wall_data.data[0]
		var motion_type_label = new_label('Motion Type: %s' % MOTION_TYPES[motion_type])
		container.add_child(motion_type_label)
		
		if motion_type == 0:  # Oscillate
			var oscillate_string = 'Vector: %s    Speed: %s    Amplitude: %s' % [
				str(wall_data.data[2]),
				snapped(wall_data.data[3], 0.01),
				snapped(wall_data.data[4], 0.01)
			]
			var oscillate_label = new_label(oscillate_string)
			container.add_child(oscillate_label)
		elif motion_type == 1:  # Rotate
			var rotate_string = 'Axis: %s    Speed: %s' % [
				str(wall_data.data[2]),
				snapped(wall_data.data[3], 0.01)
			]
			var rotate_label = new_label(rotate_string)
			container.add_child(rotate_label)
	
	var on_mouse_enter = func():
		set_panel_color(panel_container, WALL_CONTAINER_HOVER_COLOR)
		var line_node = wall_drawer.line_nodes[wall_data.index]
		saved_line_color = line_node.default_color
		line_node.default_color = LINE_HOVER_COLOR
	var on_mouse_exit = func():
		set_panel_color(panel_container, WALL_CONTAINER_COLOR)
		wall_drawer.line_nodes[wall_data.index].default_color = saved_line_color
	var on_gui_input = func(event: InputEvent):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			root.wall_edit_type = root.WallEditType.MODIFY
			root.wall_modify_index = wall_data.index
			wall_dialog.show_with_data(wall_data)
	var on_delete_pressed = func():
		root.all_wall_data.pop_at(wall_data.index)
		for i in range(wall_data.index, len(root.all_wall_data)):  # Readjust indices
			root.all_wall_data[i].index -= 1
		root.update_walls()
	
	panel_container.connect('mouse_entered', on_mouse_enter)
	panel_container.connect('mouse_exited', on_mouse_exit)
	panel_container.connect('gui_input', on_gui_input)
	
	var delete_button = Button.new()
	delete_button.text = 'Delete'
	delete_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	delete_button.connect('pressed', on_delete_pressed)
	
	parent_container.add_child(container)
	parent_container.add_child(delete_button)
	panel_container.add_child(parent_container)
	return panel_container;


func clear_children():
	for i in range(get_child_count()):
		get_child(i).queue_free()


# Clear children and recreate all containers
func update():
	clear_children()
	for i in range(len(root.all_wall_data)):
		var wall_data = root.all_wall_data[i]
		var container = generate_container(wall_data, i)
		add_child(container)
		
