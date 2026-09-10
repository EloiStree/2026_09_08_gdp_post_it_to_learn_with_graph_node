class_name PostItListenToTextEditEmit
extends Node

signal on_text_changed(text: String)
signal on_text_emitted(text: String)
signal on_emit_at_ready(text:String)

@export var _text_edit : TextEdit
@export var _emit_at_ready : bool = true
@export var _listen_to_text_change : bool = true
@export var _listen_to_text_emit : bool = true

func _ready() -> void:
	if _listen_to_text_change:
		_text_edit.text_changed.connect(_on_text_changed)
	if _listen_to_text_emit:
		_text_edit.text_set.connect(_on_text_emitted)
	on_emit_at_ready.emit(_text_edit)

func _on_text_changed() -> void:
	on_text_changed.emit(_text_edit.text)

func _on_text_emitted() -> void:
	on_text_emitted.emit(_text_edit.text)
