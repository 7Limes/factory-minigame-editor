class_name WallData


enum WallType {
	STATIC,
	DYNAMIC
}

var type: WallType
var data: Array

# The position of this data in `all_wall_data`.
var index: int
