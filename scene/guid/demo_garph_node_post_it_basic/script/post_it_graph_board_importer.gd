class_name PostItGraphBoardImporter
extends Node



@export var graph_board : GraphEdit
@export var graph_node_of_basic_post_it : PackedScene

@export var _unicode_post_it_to_background_color : Dictionary = {
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
@export var _unicode_post_it_to_text_color:Dictionary = {
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

func get_post_it_background_color_from_tag(tag:String) -> Color:
	if _unicode_post_it_to_background_color.has(tag):
		return _unicode_post_it_to_background_color[tag]
	return _unicode_post_it_to_background_color["🟨"]


func get_post_it_text_color_from_tag(tag:String) -> Color:
	if _unicode_post_it_to_text_color.has(tag):
		return _unicode_post_it_to_text_color[tag]
	return _unicode_post_it_to_text_color["⚪"]

func is_line_start_by_post_it_tag(line:String) -> bool:
	for tag in POST_IT_START_TAG:
		if line.begins_with(tag):
			return true
	return false


func is_line_start_by_post_it_text_color_tag(line:String) -> bool:
	for tag in _unicode_post_it_to_text_color.keys():
		if line.begins_with(tag):
			return true
	return false


func remove_all_children_of_graph_board():
	for child in graph_board.get_children():
		graph_board.remove_child(child)
		child.queue_free()

func create_post_it_graph_node(color_background:Color,color_text:Color, title:String, text:String, position:Vector2, size:Vector2):
	var post_it = graph_node_of_basic_post_it.instantiate() as PostItGraphNodeBasic
	post_it.set_post_it_background_color(color_background)
	post_it.set_post_it_text_color(color_text)
	post_it.set_post_it_title(title)
	post_it.set_post_it_text(text)
	post_it.set_post_it_position(position)
	post_it.set_post_it_size(size)
	graph_board.add_child(post_it)

func import_post_it_as_a_graph_board_from_text(text:String):
	remove_all_children_of_graph_board()
	var post_it_background_color:Color = Color.YELLOW
	var post_it_text_color:Color= Color.BLACK
	var post_it_title:String
	var post_it_text:String
	var post_it_position:Vector2 = Vector2.ZERO
	var post_it_size:Vector2 = Vector2(300, 150)

	var lines = text.split("\n")
	for line in lines:
		if is_line_start_by_post_it_tag(line):
			create_post_it_graph_node(post_it_background_color, post_it_text_color, post_it_title, post_it_text,post_it_position,post_it_size)
			var tag_background = line.substr(0, 1)
			post_it_background_color = get_post_it_background_color_from_tag(tag_background)
			post_it_text_color = Color.BLACK
			line = line.substr(1)
			var tag_text = line.substr(0, 1)
			if is_line_start_by_post_it_text_color_tag(line):
				post_it_text_color = get_post_it_text_color_from_tag(tag_text)
				line = line.substr(1)
			post_it_title = line.strip_edges()
			post_it_text = ""
			post_it_position = Vector2(_default_x, _default_y)
			post_it_size = Vector2(_default_width,_default_height)

		elif line.begins_with("📌") or line.begins_with("📍"):
			line = line.to_lower()
			# X200  Y100  W300  H150
			var parts = line.split("  ")
			for part in parts:
				if len(part) < 2:
					continue
				var first_char = part.substr(0, 1)
				var value = part.substr(1).strip_edges().to_int()
				match first_char:
					"x":
						post_it_position.x = value
					"y":
						post_it_position.y = value
					"w":
						post_it_size.x = value
					"h":
						post_it_size.y = value


"""
Example of the format

🟨🟣 Hello 
📌x100 y200 w200 h100
How are you ?


🟦⚪  Hey 
📌x300 y200 w200 h100
Fine and you


"""
