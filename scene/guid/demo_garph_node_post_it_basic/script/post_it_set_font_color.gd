class_name PostItSetFontColor
extends Node


@export var _target_to_affect:Control

func set_color_of_font(color_of_text:Color):
	if _target_to_affect is GraphNode or _target_to_affect is PostItGraphNodeBasic:
		_target_to_affect.add_theme_color_override("title_color", color_of_text)
		_target_to_affect.add_theme_color_override("font_color", color_of_text)
		_target_to_affect.add_theme_color_override("default_color", color_of_text)
	elif _target_to_affect is LineEdit:
		_target_to_affect.add_theme_color_override("font_color", color_of_text)
	elif _target_to_affect is RichTextLabel:
		_target_to_affect.add_theme_color_override("default_color", color_of_text)
	else:
		_target_to_affect.add_theme_color_override("font_color", color_of_text)

	
