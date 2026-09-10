class_name PostItBoardAsTextRegisterMenuButton
extends Node

signal on_selected_text_in_register(text: String)
signal on_selected_board_name_in_register(text: String)

@export var _register:PostItBoardAsTextRegister
@export var _menu_button_to_affect:MenuButton



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_register.on_any_changed.connect(_on_register_changed)
	_on_register_changed(_register._board_name_to_text)
	_menu_button_to_affect.get_popup().id_pressed.connect(_on_menu_item_selected)

func _on_register_changed(register: Dictionary[String,String]) -> void:
	var popup := _menu_button_to_affect.get_popup()
	popup.clear()
	for key in register.keys():
		popup.add_item(key)

func _on_menu_item_selected(id: int) -> void:
	var popup := _menu_button_to_affect.get_popup()
	var key = popup.get_item_text(popup.get_item_index(id))
	on_selected_board_name_in_register.emit(key)
	on_selected_text_in_register.emit(_register._board_name_to_text[key])
