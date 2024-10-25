extends Node2D


@export var spacing = 40
@export var line_width = 2.0
@export var color = Color(1.0, 1.0, 1.0, 0.25)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var half_size_vector = Vector2(spacing*10/2, spacing*10/2)
	for i in range(9):
		var line = Line2D.new()
		line.width = line_width
		line.default_color = color
		var p1 = Vector2(i*spacing+spacing, 0) - half_size_vector
		var p2 = Vector2(i*spacing+spacing, spacing*10) - half_size_vector
		line.add_point(p1)
		line.add_point(p2)
		add_child(line)
	
	for i in range(9):
		var line = Line2D.new()
		line.width = line_width
		line.default_color = color
		
		var p1 = Vector2(0, i*spacing+spacing) - half_size_vector
		var p2 = Vector2(spacing*10, i*spacing+spacing) - half_size_vector
		line.add_point(p1)
		line.add_point(p2)
		add_child(line)


func _process(delta: float) -> void:
	global_transform.origin = get_viewport_rect().size / 2
