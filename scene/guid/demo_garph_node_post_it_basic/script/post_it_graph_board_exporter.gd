class_name PostItGraphBoardExporter
extends Node


signal on_export_request(text:String)

@export var graph_board : GraphEdit

@export var _graph_post_it_basic_in_board:Array[PostItGraphNodeBasic] 

@export var _unicode_post_it_from_background_color : Dictionary = {
	"🟨": Color.YELLOW,
	"🟥": Color.RED,
	"🟦": Color.BLUE,
	"🟧": Color.ORANGE,
	"🟩": Color.GREEN,
	"🟪": Color.PURPLE,
	"🟫": Color.BROWN,
	"⬛": Color.BLACK,
	"⬜": Color.WHITE,
}
@export var _unicode_post_it_from_text_color:Dictionary = {
	"🟡": Color.YELLOW,
	"🔴": Color.RED,
	"🔵": Color.BLUE,
	"🟠": Color.ORANGE,
	"🟢": Color.GREEN,
	"🟣": Color.PURPLE,
	"🟤": Color.BROWN,
	"⚫": Color.BLACK,
	"⚪": Color.WHITE,
}


@export var _default_x:int = 20
@export var _default_y:int = 20

@export var _default_width:int = 100
@export var _default_height:int = 100


const POST_IT_START_TAG:String="🟨🟥🟦🟧🟩🟪🟫⬛⬜"
const POST_IT_POSITION_TAG:String="📍📌"
const POST_IT_COLOR:String="🎨"
const POST_IT_KEYWORD:String="🔖"
const POST_IT_UNIQUE_ID:String="🔑"
const POST_IT_URL:String="❓"


func emit_export_request():
	on_export_request.emit(get_text_version_of_post_it_graph_board())

func get_graph_node_in_graph_edit() -> Array[PostItGraphNodeBasic]:
	var post_it_nodes:Array[PostItGraphNodeBasic] = []
	for child in graph_board.get_children():
		if child is PostItGraphNodeBasic:
			post_it_nodes.append(child)
	return post_it_nodes

func get_text_version_of_post_it_graph_board() -> String:

	_graph_post_it_basic_in_board = get_graph_node_in_graph_edit()
	var text_version:String = ""
	for post_it in _graph_post_it_basic_in_board:
		text_version += get_text_version_of_post_it_graph_node(post_it)
	return text_version


func get_text_version_of_post_it_graph_node(post_it:PostItGraphNodeBasic) -> String:

	var icon:String = "🟨"
	var background_color:Color = post_it.get_post_it_background_color()
	var text_color:Color = post_it.get_post_it_text_color()
	if _unicode_post_it_from_background_color.values().has(background_color):
		icon = _unicode_post_it_from_background_color.keys()[_unicode_post_it_from_background_color.values().find(background_color)]

	if _unicode_post_it_from_text_color.values().has(text_color):
		icon += _unicode_post_it_from_text_color.keys()[_unicode_post_it_from_text_color.values().find(text_color)]

	var text_version:String = icon + post_it.get_post_it_title() + "\n"


	var position:Vector2 = post_it.get_post_it_position()
	var size:Vector2 = post_it.get_post_it_size()
	# Position and size
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


func _get_post_it_color(post_it:PostItGraphNodeBasic, method_name:String, property_name:String, default_color:Color) -> Color:
	if post_it.has_method(method_name):
		return post_it.call(method_name)
	if _has_property(post_it, property_name):
		return post_it.get(property_name)
	return default_color


func _has_property(target:Object, property_name:String) -> bool:
	for property_info in target.get_property_list():
		if property_info["name"] == property_name:
			return true
	return false
