extends Component
class_name Movie

var texture_rect:TextureRect

func _init(_props:Dictionary):
	super("movie",_props)


func component_ready():
	texture_rect = get_control("texture")
	
	var http_request = HTTPRequest.new()
	control.add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	var error = http_request.request(props.image)
	if error != OK:
			push_error("An error occurred in the HTTP request.")


func _http_request_completed(result, _response_code, _headers, body):
	# set the requested image to texture_rect
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	texture_rect.texture = ImageTexture.create_from_image(image)

func view():
	return \
	Gui.panel_container({preset="card", custom_minimum_size=Vector2(200,250)},[
		Gui.margin({const_margin_all=5}, [
			Gui.vbox({preset="expand"},[
				Gui.texture_rect({id="texture",preset="expand"}),
				Gui.label({preset="title",text=props.title}),
				Gui.label({text=str(props.rating)})
			])
		])
	])
