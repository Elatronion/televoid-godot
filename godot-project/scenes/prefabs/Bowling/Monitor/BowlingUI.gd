extends Control

signal new_frame

onready var _frame_label = $Panel/VBoxContainer/BottomPanel/CenterContainer/Label
onready var _first_throw_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/TopHBoxContainer/LeftPanel/CenterContainer/Label
onready var _second_throw_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/TopHBoxContainer/RightPanel/CenterContainer/Label
onready var _points_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/BottomHBoxContainer2/Panel/CenterContainer/Label

var Frame = {
	first_throw = null,
	second_throw = null,
	points = null
}

var current_frame_number = 1
var my_frames = [Frame.duplicate(), Frame.duplicate(), Frame.duplicate(), Frame.duplicate(), Frame.duplicate(), Frame.duplicate(), Frame.duplicate(), Frame.duplicate(), Frame.duplicate(), Frame.duplicate()]
var total_points = 0

func _ready():
	set_current_frame(1)

func do_calculations():
	calculate_frame_points()
	calculate_frame_points_with_total()
	total_points = 0

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

func is_next_shot_new_frame():
	var result = false
	var frame = my_frames[current_frame_number-1]
	if (frame.first_throw != null and frame.second_throw != null) or frame.first_throw == 10:
		result = true
	return result

func add_pins_to_frame(num_pins):
	var frame = my_frames[current_frame_number-1]
	if frame.first_throw == null:
		frame.first_throw = num_pins
		do_calculations()
		draw_frame(frame)
	elif frame.second_throw == null:
		frame.second_throw = num_pins
		do_calculations()
		draw_frame(frame)

func next_frame():
	set_current_frame(current_frame_number + 1)

func set_current_frame(frame_num):
	emit_signal("new_frame")
	do_calculations()
	current_frame_number = frame_num
	draw_frame(my_frames[frame_num-1])
	_frame_label.text = "FRAME: %d" % frame_num
