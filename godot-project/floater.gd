extends Sprite

var initial_global_y = 0
func _ready():
	global_position.x += texture.get_width()/2
	global_position.y += texture.get_height()/2
	initial_global_y = global_position.y
	offset.x = -texture.get_width()/2
	offset.y = -texture.get_height()/2

var t = 0
func _process(delta):
	t+=delta
	global_position.y = initial_global_y + sin(global_position.x + t) * 5
	rotation = cos(global_position.x + t*0.5) * 0.25
