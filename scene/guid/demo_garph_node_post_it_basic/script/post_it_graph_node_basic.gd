class_name PostItGraphNodeBasic
extends GraphNode

@export var _text_holder : TextEdit
@export var _color_background_at_start : Color = Color("#FFF700")
@export var _color_text_at_start : Color = Color("#000000")

func _enter_tree():
	set_post_it_background_color(_color_background_at_start)
	set_post_it_text_color(_color_text_at_start)	


func set_post_it_title(text:String):
	self.title=text
	
func set_post_it_text(text:String):
	_text_holder.set_text(text)

func get_post_it_title():
	return self.title
	
func get_post_it_text():
	return _text_holder.text


func set_post_it_background_color(color_of_post_it:Color):
	## Set the graph node color
	self.self_modulate=color_of_post_it
	_text_holder.self_modulate=color_of_post_it

func set_post_it_text_color(color_of_text:Color):
	_text_holder.add_theme_color_override("font_color", color_of_text)


func set_post_it_size(size:Vector2):
	self.set_size(size)


func set_post_it_position(position:Vector2):
	self.set_position(position)
	
