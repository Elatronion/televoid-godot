extends Sprite

var initial_global_y = 0
func _ready():
	initial_global_y = get_parent().global_position.y
	
var t = 0
func _process(delta):
	t+=delta
	get_parent().global_position.y = initial_global_y + sin(get_parent().global_position.x + t*3)
	get_parent().rotation = cos(get_parent().global_position.x + t) * 0.25
