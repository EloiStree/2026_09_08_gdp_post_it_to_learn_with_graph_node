class_name PostItGraphBoardImporter
extends Node



@export var graph_board : GraphEdit
@export var graph_node_of_basic_post_it : PackedScene

@export var _created_to_flush:Array[PostItGraphNodeBasic] 

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


const POST_IT_START_TAGS = ["🟨", "🟥", "🟦", "🟧", "🟩", "🟪", "🟫", "⬛", "⬜"]
const POST_IT_POSITION_TAGS = ["📍", "📌"]

func get_post_it_background_color_from_tag(tag:String) -> Color:
	if _unicode_post_it_to_background_color.has(tag):
		return _unicode_post_it_to_background_color[tag]
	return _unicode_post_it_to_background_color["🟨"]


func get_post_it_text_color_from_tag(tag:String) -> Color:
	if _unicode_post_it_to_text_color.has(tag):
		return _unicode_post_it_to_text_color[tag]
	return _unicode_post_it_to_text_color["⚪"]

func is_line_start_by_post_it_tag(line:String) -> bool:
	for tag in POST_IT_START_TAGS:
		if line.begins_with(tag):
			return true
	return false


func is_line_start_by_post_it_position_tag(line:String) -> bool:
	for tag in POST_IT_POSITION_TAGS:
		if line.begins_with(tag):
			return true
	return false


func is_line_start_by_post_it_text_color_tag(line:String) -> bool:
	for tag in _unicode_post_it_to_text_color.keys():
		if line.begins_with(tag):
			return true
	return false


func remove_all_children_of_graph_board():
	for child in _created_to_flush:
		if child:
			graph_board.remove_child(child)
			child.queue_free()
	_created_to_flush.clear()

func create_post_it_graph_node(color_background:Color,color_text:Color, title:String, text:String, position:Vector2, size:Vector2) -> PostItGraphNodeBasic:
	var post_it = graph_node_of_basic_post_it.instantiate() as PostItGraphNodeBasic
	_created_to_flush.append(post_it)
	graph_board.add_child(post_it)
	_configure_post_it_when_ready(post_it, color_background, color_text, title, text, position, size)
	return post_it

func _configure_post_it_when_ready(post_it:PostItGraphNodeBasic, color_background:Color, color_text:Color, title:String, text:String, position:Vector2, size:Vector2):
	post_it.set_post_it_background_color(color_background)
	post_it.set_post_it_text_color(color_text)
	post_it.set_post_it_title(title)
	post_it.set_post_it_text(text)
	post_it.set_post_it_size(size)
	post_it.set_post_it_position(position)


func _apply_post_it_metadata(post_it:PostItGraphNodeBasic, unique_id:String, keyword:String, url:String):
	if unique_id != "":
		post_it.set_post_it_unique_id(unique_id)
	if keyword != "":
		post_it.set_post_it_linked_keyword(keyword)
	if url != "":
		post_it.set_post_it_documentation_url(url)

func import_post_it_as_a_graph_board_from_text(text:String):
	remove_all_children_of_graph_board()
	var post_it_background_color:Color = Color.YELLOW
	var post_it_text_color:Color= Color.WHITE
	var post_it_title:String
	var post_it_text:String = ""
	var post_it_position:Vector2 = Vector2.ZERO
	var post_it_size:Vector2 = Vector2(300, 150)
	var has_pending_post_it:bool = false
	var post_it_unique_id:String = ""
	var post_it_keyword:String = ""
	var post_it_url:String = ""
	var created_graph_node:PostItGraphNodeBasic = null

	var lines = text.split("\n")
	for line in lines:
		if is_line_start_by_post_it_tag(line):
			if has_pending_post_it:
				created_graph_node = create_post_it_graph_node(post_it_background_color, post_it_text_color, post_it_title, post_it_text.strip_edges(),post_it_position,post_it_size)
				_apply_post_it_metadata(created_graph_node, post_it_unique_id, post_it_keyword, post_it_url)
			has_pending_post_it = true
			var tag_background = line.substr(0, 1)
			post_it_background_color = get_post_it_background_color_from_tag(tag_background)
			post_it_text_color = Color.WHITE
			line = line.substr(1)
			if line.length() > 0 and is_line_start_by_post_it_text_color_tag(line):
				var tag_text = line.substr(0, 1)
				post_it_text_color = get_post_it_text_color_from_tag(tag_text)
				line = line.substr(1)
			post_it_title = line.strip_edges()
			post_it_text = ""
			post_it_position = Vector2(_default_x, _default_y)
			post_it_size = Vector2(_default_width,_default_height)
			post_it_unique_id = ""
			post_it_keyword = ""
			post_it_url = ""

		elif has_pending_post_it and is_line_start_by_post_it_position_tag(line):
			var lower_line = line.to_lower()
			# X200  Y100  W300  H150
			var parts = lower_line.substr(1).split(" ", false)
			for part in parts:
				part = part.strip_edges()
				if part.length() < 2:
					continue
				var first_char = part.substr(0, 1)
				var value = part.substr(1).strip_edges().to_float()
				match first_char:
					"x":
						post_it_position.x = value
					"y":
						post_it_position.y = value
					"w":
						post_it_size.x = value
					"h":
						post_it_size.y = value
		elif has_pending_post_it and line.begins_with("🔑"):
			post_it_unique_id = line.substr(1).strip_edges()
		elif has_pending_post_it and line.begins_with("🔖"):
			post_it_keyword = line.substr(1).strip_edges()
		elif has_pending_post_it and line.begins_with("❓"):
			post_it_url = line.substr(1).strip_edges()
		elif has_pending_post_it and line.begins_with("🎨"):
			var colors = line.substr(1).strip_edges().split(" ", false)
			if colors.size() >= 1:
				post_it_background_color = Color(colors[0])
			if colors.size() >= 2:
				post_it_text_color = Color(colors[1])
		elif has_pending_post_it:
			post_it_text += line + "\n"

	if has_pending_post_it:
		created_graph_node = create_post_it_graph_node(post_it_background_color, post_it_text_color, post_it_title, post_it_text.strip_edges(),post_it_position,post_it_size)
		_apply_post_it_metadata(created_graph_node, post_it_unique_id, post_it_keyword, post_it_url)


"""
Example of the format

🟨🟣 Hello 
📌x100 y200 w200 h100
How are you ?


🟦⚪  Hey 
📌x300 y200 w200 h100
Fine and you

# Blue post it with green text. Title is "Hey"
🟦🟢  Hey 
# Post it position and width/height
📌x300 y200 w200 h100
# Unique idea of the post it in the contact of the board (optional)
🔑Hello206
# Notify that this post it is linked to a keyboard 
🔖var
# Notify that this post has documentation at this url.
❓https://github.com/EloiStree/2026_09_08_gdp_post_it_to_learn_with_graph_node

#Text in the posting.
Fine and you



🟨Hello World
📌x20 y20 w266 h
🔑HelloWorld42
❓https://fr.wikipedia.org/wiki/Hello_world
🔖Hello World
🎨 00ffff 0f0fff


"""
