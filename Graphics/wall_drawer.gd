extends Node2D


@onready var grid_spacing = $"../GridGenerator".spacing
@onready var half_size_vector = Vector2(grid_spacing*10/2, grid_spacing*10/2)
@onready var root = $".."


# Array[Line2D]
var line_nodes: Array = []


func clear_children():
	for i in range(get_child_count()):
		get_child(i).queue_free()


func add_line(segment: Array, color: Color):
	var line = Line2D.new()
	line.default_color = color
	line.width = 3
	var p1 = Vector2(segment[0], segment[1]) * grid_spacing - half_size_vector
	var p2 = Vector2(segment[2], segment[3]) * grid_spacing - half_size_vector
	line.add_point(p1)
	line.add_point(p2)
	add_child(line)
	line_nodes.append(line)


# Clear all Line2Ds and redraw the level
func update():
	clear_children()
	line_nodes.clear()
	
	for wall_data: WallData in root.all_wall_data:
		if wall_data.type == WallData.WallType.STATIC:
			var segment = wall_data.data
			add_line(segment, Color(1.0, 1.0, 1.0))
		elif wall_data.type == WallData.WallType.DYNAMIC:
			var motion_type = wall_data.data[0]
			if motion_type == 0:  # Oscillate
				add_line(wall_data.data[1], Color(0.5, 0.5, 1.0))
			elif motion_type == 1:  # Rotate
				add_line(wall_data.data[1], Color(1.0, 0.5, 0.5))


func _process(delta: float) -> void:
	global_transform.origin = get_viewport_rect().size / 2 + Root.GRID_OFFSET
