extends Control

onready var _frame_label = $Panel/VBoxContainer/BottomPanel/CenterContainer/Label
onready var _first_throw_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/TopHBoxContainer/LeftPanel/CenterContainer/Label
onready var _second_throw_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/TopHBoxContainer/RightPanel/CenterContainer/Label
onready var _points_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/BottomHBoxContainer2/Panel/CenterContainer/Label

var Frame = {
	first_throw = null,
	second_throw = null,
	points = null
}

var my_frames = [Frame.duplicate(), Frame.duplicate(), Frame.duplicate()]
var total_points = 0

func _ready():
	var f1 = my_frames[0]
	var f2 = my_frames[1]
	var f3 = my_frames[2]
	f1.first_throw = 10
	
	f2.first_throw = 3
	f2.second_throw = 5
	
	f3.first_throw = 7
	f3.second_throw = 3
	
	calculate_frame_points()
	calculate_frame_points_with_total()
	
	for my_frame in my_frames:
		print_frame(my_frame)
	
	total_points = 0
	draw_frame(f1)

func calculate_frame_points():
	for i in range(0, len(my_frames)):
		var my_frame = my_frames[i]
		var next_frame = Frame.duplicate()
		next_frame.first_throw = 0
		next_frame.second_throw = 0
		var next_next_frame = Frame.duplicate()
		next_next_frame.first_throw = 0
		next_next_frame.second_throw = 0
		if i + 1 < len(my_frames):
			next_frame = my_frames[i+1]
		if i + 2 < len(my_frames):
			next_next_frame = my_frames[i+2]
		
		if my_frame.first_throw == null:
			continue
		
		if my_frame.first_throw == 10:
			if next_frame.first_throw != null:
				if next_frame.second_throw != null:
					my_frame.points = my_frame.first_throw + next_frame.first_throw + next_frame.second_throw
				if next_frame.first_throw == 10:
					if next_next_frame.first_throw != null:
						my_frame.points = my_frame.first_throw + next_frame.first_throw + next_next_frame.first_throw
			continue
		
		if my_frame.second_throw == null:
			continue
		
		if my_frame.first_throw + my_frame.second_throw == 10:
			if next_frame.first_throw != null:
				my_frame.points = my_frame.first_throw + my_frame.second_throw + next_frame.first_throw
			continue
		
		if my_frame.points == null:
			my_frame.points = my_frame.first_throw + my_frame.second_throw

func calculate_frame_points_with_total():
	for my_frame in my_frames:
		if my_frame.points != null:
			total_points += my_frame.points
			my_frame.points = total_points
			

func print_frame(my_frame):
	print("\n| %s L %s |\n|   %s   |\n" % [str(my_frame.first_throw), str(my_frame.second_throw), str(my_frame.points)])

func draw_frame(my_frame):
	_first_throw_label.text = ""
	_second_throw_label.text = ""
	_points_label.text = ""
	
	var frame_total_points = my_frame.points
	if frame_total_points != null:
		_points_label.text = str(frame_total_points)
	
	if my_frame.first_throw != null:
		if my_frame.first_throw == 10:
			_first_throw_label.text = "X"
		else:
			_first_throw_label.text = str(my_frame.first_throw)
	
	if my_frame.second_throw != null:
		if my_frame.first_throw + my_frame.second_throw == 10:
			_second_throw_label.text = "/"
		else:
			_second_throw_label.text = str(my_frame.second_throw)
	

#var _current_throw = 0
#var _frame = 1
#var _total_points = 0
#var _total_downed_pins = 0
#var _first_throw_pins = 0
#var _second_throw_pins = 0
#var is_first_shot = true
#var _frame_end = false

#var BowlingFrame = {
#	audio_master = 0,
#	audio_bgm = -12,
#	audio_sfx = -5,
#	audio_voice = -10
#}

#var BowlingFrames[10]

#func _ready():
#	_CleanUIScore()
#	RegisterThrow(5)
#	RegisterThrow(3)
#	RegisterThrow(10)
#	_update_graphics()

#func _CleanUIScore():
#	_points_label.text = ""
#	_throw1_pins.text = ""
#	_throw2_pins.text = ""

#func RegisterNewFrame():
#	_frame += 1
#	_throw1_pins.text = ""
#	_throw2_pins.text = ""
#	_update_graphics()

#func RegisterThrow(downed_pins):
#	_total_downed_pins += downed_pins
#	_current_throw += 1
#	_update_graphics()
#
#func _IsFirstShot():
#	return _current_throw % 2 == 1
#
#func _update_graphics():
#	if _IsFirstShot():
#		if _total_downed_pins == 10:
#			_throw1_pins.text = "X"
#			_throw2_pins.text = ""
#		else:
#			_throw1_pins.text = str(_total_downed_pins)
#	else:
#		if _total_downed_pins == 10:
#			_throw2_pins.text = "/"
#		else:
#			_throw2_pins.text = str(_total_downed_pins)
#
#	_points_label.text = str(_total_points)
#	_frame_label.text = "FRAME: %d" % _frame

var idx = 0
func _on_Timer_timeout():
	idx += 1
	if idx >= len(my_frames):
		idx = 0
	draw_frame(my_frames[idx])
	_frame_label.text = "FRAME: %d" % (idx+1)
