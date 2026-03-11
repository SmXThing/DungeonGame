extends Node


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
