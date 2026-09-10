class_name PostItGraphNodeBasic
extends GraphNode


signal on_post_it_title_set(new_title:String)
signal on_post_it_text_set(new_text:String)

signal on_post_it_background_color_set(new_color:Color)
signal on_post_it_text_color_set(new_color:Color)

signal on_post_it_size_set(new_size:Vector2)
signal on_post_it_position_set(new_position:Vector2)
signal on_post_it_any_change()



@export var _color_background_at_start : Color = Color("#FFF700")
@export var _color_text_at_start : Color = Color("ffffffff")


@export var _post_it_title : String
## Text contained within the post-it.
@export var _post_it_text : String
## Position and size of the post-it on the graph node canvas. Top-left to Down Right
@export var _post_it_position : Vector2
## Size of the post-it on the graph node canvas.
@export var _post_it_size : Vector2

## Unique identifier for this post-it given by the post-it creator for it architecture to reference it uniquely.
@export var _unique_id : String

## Notify that this post-it linked to a keyword to learn
@export var _linked_keyword : String

## Notify that there is more information about this post-it at an url for documentation.
@export var _documentation_url : String

@export var _is_in_edit_mode: bool = false


var _last_background_color_set:Color
var _last_text_color_set:Color

func _ready() -> void:
	self.node_deselected.connect(set_as_view_mode)
	self.node_selected.connect(set_as_edit_mode)

func is_in_edit_mode():
	return _is_in_edit_mode

func set_in_edit_mode(edit_mode: bool):
	_is_in_edit_mode = edit_mode
	on_post_it_any_change.emit()

func set_as_edit_mode():
	set_in_edit_mode(true)

func set_as_view_mode():
	set_in_edit_mode(false)


const RANDOM_GUID_CHAR = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const RANDOM_GUID_LENGTH = 32
func set_post_it_unique_id_with_generate_random_guid():
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var guid := ""
	for _i in range(RANDOM_GUID_LENGTH):
		guid += RANDOM_GUID_CHAR[rng.randi_range(0, RANDOM_GUID_CHAR.length() - 1)]
	set_post_it_unique_id(guid)




func _enter_tree():
	set_post_it_background_color(_color_background_at_start)
	set_post_it_text_color(_color_text_at_start)


func set_post_it_title(given_title:String):
	self.title=given_title
	self._post_it_title=given_title
	on_post_it_title_set.emit(given_title)
	on_post_it_any_change.emit()

func set_post_it_text(given_text:String):
	self._post_it_text= given_text
	on_post_it_text_set.emit(given_text)
	on_post_it_any_change.emit()

func get_post_it_title():
	if _post_it_title.is_empty():
		return self.title
	return self._post_it_title
	
func get_post_it_text():
	return self._post_it_text 

func set_post_it_background_color(color_of_post_it:Color):
	## Set the graph node color
	self.self_modulate=color_of_post_it
	_last_background_color_set = color_of_post_it
	on_post_it_background_color_set.emit(color_of_post_it)
	on_post_it_any_change.emit()

func set_post_it_text_color(color_of_text:Color):
	#_text_holder.add_theme_color_override("font_color", color_of_text)
	_last_text_color_set = color_of_text
	on_post_it_text_color_set.emit(color_of_text)
	on_post_it_any_change.emit()



func get_post_it_size():
	return self.get_size()

func get_post_it_position():
	return self.position_offset

func set_post_it_size(size:Vector2):
	self.set_size(size)
	on_post_it_size_set.emit(size)
	on_post_it_any_change.emit()

func get_post_it_background_color() -> Color:
	return _last_background_color_set

func get_post_it_text_color() -> Color:
	return _last_text_color_set

func get_post_it_unique_id():
	return self._unique_id

func get_post_it_url():
	return self._documentation_url

func get_post_it_keyword():
	return self._linked_keyword

func has_unique_id():
	return _unique_id != ""

func has_keyword():
	return _linked_keyword != ""

func has_url():
	return _documentation_url != ""

func set_post_it_position(position:Vector2):
	self.position_offset = position
	on_post_it_position_set.emit(position)
	on_post_it_any_change.emit()

func set_post_it_unique_id(unique_id:String):
	_unique_id = unique_id
	on_post_it_any_change.emit()

func set_post_it_linked_keyword(linked_keyword:String):
	_linked_keyword  = linked_keyword
	on_post_it_any_change.emit()

func set_post_it_documentation_url(url:String):
	_documentation_url = url
	on_post_it_any_change.emit()
	
func push_unique_id_in_clipboard():
	DisplayServer.clipboard_set(_unique_id)

func open_documentation_url():
	if _documentation_url != "":
		OS.shell_open(_documentation_url)

func open_linked_keyword_in_google():
	if _linked_keyword != "":
		OS.shell_open("https://www.google.com/search?q=" + _linked_keyword)



func export_as_string_node_to_clipboard():
	DisplayServer.clipboard_set(get_text_version_of_post_it_graph_node(self))


static func get_text_version_of_post_it_graph_node(post_it:PostItGraphNodeBasic) -> String:

	var icon:String = "🟨"
	var background_color:Color = post_it.get_post_it_background_color()
	var text_color:Color = post_it.get_post_it_text_color()
	var text_version:String = icon + post_it.get_post_it_title() + "\n"
	var position:Vector2 = post_it.get_post_it_position()
	var size:Vector2 = post_it.get_post_it_size()
	if post_it.get_post_it_url() != "":
		text_version += POST_IT_URL + post_it.get_post_it_url() + "\n"
	text_version += "📌x" + str(position.x) + " y" + str(position.y)
	text_version += " w" + str(size.x) + " h" + str(size.y) + "\n"
	if post_it.has_unique_id():
		text_version += POST_IT_UNIQUE_ID + post_it.get_post_it_unique_id() + "\n"
	if post_it.has_keyword():
		text_version += POST_IT_KEYWORD + post_it.get_post_it_keyword() + "\n"
	text_version += POST_IT_COLOR +" " + background_color.to_html(false)+ " "
	text_version += text_color.to_html(false) + "\n"
	

	text_version += post_it.get_post_it_text() + "\n\n\n"
	return text_version

const POST_IT_COLOR:String="🎨"
const POST_IT_KEYWORD:String="🔖"
const POST_IT_UNIQUE_ID:String="🔑"
const POST_IT_URL:String="❓"



func set_from_other_post_it(other:PostItGraphNodeBasic):
	set_post_it_unique_id(other.get_post_it_unique_id())
	set_post_it_linked_keyword(other.get_post_it_keyword())
	set_post_it_documentation_url(other.get_post_it_url())
	set_post_it_position(other.get_post_it_position())
	set_post_it_size(other.get_post_it_size())
	set_post_it_background_color(other.get_post_it_background_color())
	set_post_it_text_color(other.get_post_it_text_color())
	set_post_it_title(other.get_post_it_title())
	set_post_it_text(other.get_post_it_text())
