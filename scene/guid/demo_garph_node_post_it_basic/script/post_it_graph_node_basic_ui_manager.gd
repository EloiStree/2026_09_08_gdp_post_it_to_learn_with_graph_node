class_name PostItGraphNodeBasicUiManager
extends Node



@export var _source:PostItGraphNodeBasic

@export var _panel_edit_post_it: Panel
@export var _panel_view_post_it: Panel

@export var _panel_buttons_of_post_it: Control
@export var _button_node_unique_id: Button
@export var _button_node_keyword: Button
@export var _button_node_url: Button

@export var _color_picker_background:ColorPickerButton
@export var _color_picker_text:ColorPickerButton	

@export var _line_edit_title:LineEdit
@export var _line_edit_text:TextEdit
@export var _line_edit_unique_id:LineEdit
@export var _line_edit_keyword:LineEdit
@export var _line_edit_url:LineEdit




func _ready():
	refresh()
	_source.on_post_it_any_change.connect(refresh)
	_source.node_deselected.connect(set_post_it_in_view_mode)
	_source.node_selected.connect(set_post_it_in_view_mode)

func set_post_it_in_edit_mode():
	_panel_edit_post_it.visible = true
	_panel_view_post_it.visible = false

func set_post_it_in_view_mode():
	_panel_edit_post_it.visible = false
	_panel_view_post_it.visible = true

func set_post_it_in_edit_mode_with_boolean(is_edit_mode: bool):
	if is_edit_mode:
		set_post_it_in_edit_mode()
	else:
		set_post_it_in_view_mode()


func refresh():
	if _source.is_in_edit_mode():
		set_post_it_in_edit_mode()
	else:
		set_post_it_in_view_mode()
	
	var has_any_button:bool= _source.has_url() or _source.has_keyword() or _source.has_unique_id()
	
	_button_node_url.visible= _source.has_url()
	_button_node_keyword.visible= _source.has_keyword()
	_button_node_unique_id.visible= _source.has_unique_id()
	if _panel_buttons_of_post_it:
		_panel_buttons_of_post_it.visible = has_any_button


	_panel_edit_post_it.visible = _source.is_in_edit_mode()
	_panel_view_post_it.visible = not _source.is_in_edit_mode()

	_line_edit_title.text = _source.get_post_it_title()
	_line_edit_text.text = _source.get_post_it_text()
	_line_edit_unique_id.text = _source.get_post_it_unique_id()
	_line_edit_keyword.text = _source.get_post_it_keyword()
	_line_edit_url.text = _source.get_post_it_url()
