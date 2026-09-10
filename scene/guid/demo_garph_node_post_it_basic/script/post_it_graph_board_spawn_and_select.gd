class_name PostItGraphBoardSpawnAndSelect
extends Node


@export var _graph_edit_to_affect:GraphEdit
@export var _post_it_to_spawn:PackedScene


@export_group("Buttons")
@export var _spawn_button:Array[Button]
@export var _duplicate_selected_button:Array[Button]
@export var _delete_selected_button:Array[Button]
@export var _delete_all_button:Array[Button]


func _ready():
	for button in _spawn_button:
		button.pressed.connect(spawn_post_it)
	for button in _duplicate_selected_button:
		button.pressed.connect(duplicate_selected_post_it)
	for button in _delete_selected_button:
		button.pressed.connect(delete_selected_post_it)
	for button in _delete_all_button:
		button.pressed.connect(delete_all_post_its)

func spawn_post_it():
	if _graph_edit_to_affect and _post_it_to_spawn:
		var post_it_instance = _post_it_to_spawn.instantiate()
		_graph_edit_to_affect.add_child(post_it_instance)
		_graph_edit_to_affect.add_child(post_it_instance)
		post_it_instance.set_position(Vector2(100, 100))

func duplicate_selected_post_it():
	if _graph_edit_to_affect and _post_it_to_spawn:
		var selected_post_its:Array[PostItGraphNodeBasic] = []
		for node in _graph_edit_to_affect.get_children():
			if node is PostItGraphNodeBasic and node.is_selected():
				selected_post_its.append(node)

		for node in selected_post_its:
			var duplicate_instance := _post_it_to_spawn.instantiate()
			_graph_edit_to_affect.add_child(duplicate_instance)
			duplicate_instance.set_from_other_post_it(node)


func delete_selected_post_it():
	if _graph_edit_to_affect:
		for node in _graph_edit_to_affect.get_children():
			if node is PostItGraphNodeBasic and node.is_selected():
				_graph_edit_to_affect.remove_child(node)
				node.queue_free()

func delete_all_post_its():
	if _graph_edit_to_affect:
		for node in _graph_edit_to_affect.get_children():
			if node is PostItGraphNodeBasic:
				_graph_edit_to_affect.remove_child(node)
				node.queue_free()
