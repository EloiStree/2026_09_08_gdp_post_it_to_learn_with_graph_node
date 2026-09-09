class_name PostItListenToTextEditEmit
extends Node

signal on_text_changed(new_text: String)
signal on_text_emitted(new_text: String)

@export var _text_edit : TextEdit
@export var _listen_to_text_change : bool = true
@export var _listen_to_text_emit : bool = true

func _ready() -> void:
	if _listen_to_text_change:
		_text_edit.text_changed.connect(_on_text_changed)
	if _listen_to_text_emit:
		_text_edit.text_set.connect(_on_text_emitted)

func _on_text_changed() -> void:
	on_text_changed.emit(_text_edit.text)

func _on_text_emitted() -> void:
	on_text_emitted.emit(_text_edit.text)
