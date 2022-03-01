extends CanvasLayer

export var minigame_tootlwren = false

func _ready():
	minigame_tootlwren.connect("render", self, "render")
	minigame_tootlwren.connect("render_text", self, "render_text")
	minigame_tootlwren.connect("load_texture", self, "load_texture")
	minigame_tootlwren.connect("load_audio", self, "load_audio")
	minigame_tootlwren.connect("play_sfx", self, "play_sfx")
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
	resource_audio[audio_name] = load(audio_path)

func play_sfx(audio_name):
	#GameManager.PlaySFX(resource_audio[audio_name])
	if resource_audio.has(audio_name):
		$AudioStreamPlayer.stream = resource_audio[audio_name]
		$AudioStreamPlayer.play()
	else:
		GameManager.PlaySFX(audio_name)
		print("ERROR::MINIGAME::AUDIO_NOT_FOUND : '" + audio_name + "'")

var nodes_to_render = []
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
	nodes_to_render.append(sprite)

var VHS_theme = preload("res://VHS.theme")
func render_text(text, x, y, font_size):
	var center_container = CenterContainer.new()
	center_container.rect_size = get_viewport().size
	var label = Label.new()
	
	label.theme = VHS_theme
	label.text = text
	label.align = HALIGN_CENTER
	label.valign = VALIGN_CENTER

	center_container.add_child(label)
	
	center_container.rect_position.x = x
	center_container.rect_position.y = -y
	
	nodes_to_render.append(center_container)

func _process(delta):
	if GameManager.game_state == GameManager.GameState.DIALOGUE:
		return
	GameManager.SetState(GameManager.GameState.MINIGAME)
	minigame_tootlwren.func_minigame_update(delta)
	
	# Create viewport
	var viewport = Viewport.new()
	viewport.size = Vector2(get_viewport().size.x, get_viewport().size.y)
	viewport.render_target_update_mode=Viewport.UPDATE_ALWAYS
	viewport.transparent_bg = true
	
	nodes_to_render.invert()
	for node in nodes_to_render:
		viewport.add_child(node)
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
	nodes_to_render.clear()
