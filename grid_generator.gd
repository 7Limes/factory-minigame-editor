extends Node2D


@export var spacing = 40
@export var line_width = 2.0
@export var color = Color(1.0, 1.0, 1.0, 0.25)


func new_line() -> Line2D:
	var line = Line2D.new()
	line.width = line_width
	line.default_color = color
	return line
	

func add_line(line: Line2D, p1: Vector2, p2: Vector2):
	line.add_point(p1)
	line.add_point(p2)
	add_child(line)


func add_number_label(n: int, pos: Vector2):
	var label = Label.new()
	label.text = str(n)
	label.position = pos
	add_child(label)


func _ready() -> void:
	var half_size_vector = Vector2(spacing*10/2, spacing*10/2)
	for i in range(9):
		var line = new_line()
		
		var p1 = Vector2(i*spacing+spacing, 0) - half_size_vector
		var p2 = Vector2(i*spacing+spacing, spacing*10) - half_size_vector
		add_line(line, p1, p2)
		add_number_label(i+1, p1 + Vector2(-5, -30))
	
	for i in range(9):
		var line = new_line()
		
		var p1 = Vector2(0, i*spacing+spacing) - half_size_vector
		var p2 = Vector2(spacing*10, i*spacing+spacing) - half_size_vector
		add_line(line, p1, p2)
		add_number_label(i+1, p1 + Vector2(-20, -10))


func _process(delta: float) -> void:
	global_transform.origin = get_viewport_rect().size / 2
