extends Node

const directions: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT
]

func _ready() -> void:
	pass

func get_num_files(dir_path: String, file_type: String) -> int:
	var count: int = 0
	
	var directory: DirAccess = DirAccess.open(dir_path)
	if directory:
		directory.list_dir_begin()
		var file_name: String = directory.get_next()
		
		while file_name != "":
			if !directory.current_is_dir() && file_name.get_extension() == file_type:
				count += 1
			file_name = directory.get_next()
		
		directory.list_dir_end()
	else:
		print("Directory does not exist.")
	
	return count

func display_dir_uid(dir: String) -> void:
	var directory: DirAccess = DirAccess.open(dir)
	if directory:
		directory.list_dir_begin()
		var file_name: String = directory.get_next()
		while file_name != "":
			if directory.current_is_dir():
				display_dir_uid(dir + file_name + "/")
			else:
				var resource_path: int = ResourceLoader.get_resource_uid(dir + file_name)
				if resource_path != -1:
					print(ResourceUID.get_id_path(resource_path) + "\n" + ResourceUID.path_to_uid(ResourceUID.get_id_path(resource_path)) + "\n")
			file_name = directory.get_next()
		directory.list_dir_end()
