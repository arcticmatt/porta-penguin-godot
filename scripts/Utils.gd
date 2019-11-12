extends Node

func get_texture(path):
	# Get the image from the StreamTexture instead of using Image.load(), otherwise
	# the game won't work when we export it.
	var stream_texture = load(path)
	var image_texture = ImageTexture.new()
	var image = stream_texture.get_data()
	image.lock()
	# Need the second argument to avoid blurring!!!
	image_texture.create_from_image(image, 0)
	return image_texture