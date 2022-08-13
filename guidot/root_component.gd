extends BaseRootComponent
class_name RootComponent

func _init():
	super()
	presets_path = "res://styles.tscn"
	state = {
		movies = []
	}

func component_ready():
	var http_request = HTTPRequest.new()
	control.add_child(http_request)
	http_request.request_completed.connect(http_request_completed)
	var error = http_request.request("https://imdb-api.com/en/API/Top250Movies/k_fw327m7w")
	if error != OK:
		state.error ="An error occurred in the HTTP request."


func http_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	state.movies = response.items
	update_view()


func view():
	return Gui.scrollbox({preset="full"},[
		Gui.margin({preset="expand", const_margin_all=30},[
			Gui.hflow({preset="movies-container expand", list=state.movies.hash()},
				state.movies.map(func(movie):return Movie.new({
					title = movie.title, 
					rating = movie.imDbRating, 
					image = movie.image, 
					key = movie.id
				}))
			),
			Gui.show_if(state.movies.size() == 0,
				Gui.center({preset="expand"}, [
					Gui.label({text="LOADING..."})
				])
			)
		])
	])
