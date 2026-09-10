class_name PostItSetColorModulate
extends Node

@export var _target:Control
@export var _use_module:bool=false
@export var _use_self_module:bool=true
func set_color_of_modulate(color:Color):
	if _use_self_module:
		_target.self_modulate = color	
	if _use_module:
		_target.modulate = color
		
