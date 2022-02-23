extends CanvasLayer

export var minigame_tootlwren = false

func _ready():
	minigame_tootlwren.connect("render", self, "render")
	minigame_tootlwren.connect("load_texture", self, "load_texture")
	minigame_tootlwren.connect("load_audio", self, "load_audio")
	load_texture("res/textures/GUI/arcade_screen.png", "arcade screen")
	load_texture("res/textures/GUI/wheelygoodbackground.png", "wheel-y good background")
	load_texture("res/HGE/BLACK.png", "BLACK")

func init(source):
	minigame_tootlwren.init_wren_minigame(source)

var resource_textures = {}
func load_texture(sprite_path, sprite_name):
	resource_textures[sprite_name] = load(sprite_path)

var resource_audio = {}
func load_audio(audio_path, audio_name):
	resource_textures[audio_name] = load(audio_path)

var sprites_to_render = []
func render(sprite_name, x, y, w, h, r):
	var sprite = Sprite.new()
	if resource_textures.has(sprite_name):
		sprite.texture = resource_textures[sprite_name]
	else:
		print("ERROR::MINIGAME::TEXTURE_NOT_FOUND : '"+sprite_name+"'")
		sprite.texture = resource_textures["BLACK"]
	sprite.position.x = x + get_viewport().size.x/2 
	sprite.position.y = -y + get_viewport().size.y/2
	sprite.scale.x = w * 1/sprite.texture.get_width()
	sprite.scale.y = h * 1/sprite.texture.get_height()
	sprite.rotation = deg2rad(r)
	sprites_to_render.append(sprite)

func _process(delta):
	minigame_tootlwren.func_minigame_update(delta)
	
	# Create viewport
	var viewport = Viewport.new()
	viewport.size = Vector2(get_viewport().size.x, get_viewport().size.y)
	viewport.render_target_update_mode=Viewport.UPDATE_ALWAYS
	viewport.transparent_bg = true
	
	sprites_to_render.invert()
	for sprite in sprites_to_render:
		viewport.add_child(sprite)
	add_child(viewport)
	
	# Wait for content
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	# Fetch viewport content
	var texture = viewport.get_texture()
	
	var image = texture.get_data()
	image.lock()
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(image)
	image.unlock()
	
	var minigame_screen = $Sprite
	minigame_screen.texture = image_texture
	minigame_screen.position.x = get_viewport().size.x/2
	minigame_screen.position.y = get_viewport().size.y/2
	
	viewport.free()
	sprites_to_render.clear()
