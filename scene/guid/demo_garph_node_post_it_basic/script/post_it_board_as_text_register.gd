class_name  PostItBoardAsTextRegister
extends Node 
signal on_set_key_value_changed(board_name:String, text:String)
signal on_last_text_set(text:String)

signal on_any_changed(register: Dictionary[String,String])
@export var _board_name_to_text :Dictionary[String,String]


func get_text_for_board(board_name:String) -> String:
	return _board_name_to_text.get(board_name, "")

func has_text_for_board(board_name:String) -> bool:
	return _board_name_to_text.has(board_name)

func set_text_for_board(board_name:String, text:String) -> void:
	_board_name_to_text[board_name] = text
	on_set_key_value_changed.emit(board_name, text)
	on_last_text_set.emit(text)
	on_any_changed.emit(_board_name_to_text)
