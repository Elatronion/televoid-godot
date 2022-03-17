extends Control

signal new_frame

onready var _frame_label = $Panel/VBoxContainer/BottomPanel/CenterContainer/Label
onready var _current_first_throw_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/TopHBoxContainer/LeftPanel/CenterContainer/Label
onready var _current_second_throw_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/TopHBoxContainer/RightPanel/CenterContainer/Label
onready var _current_points_label = $Panel/VBoxContainer/HBoxContainer/CurrentFrame/VBoxContainer/BottomHBoxContainer2/Panel/CenterContainer/Label

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
	total_points = 0
	calculate_frame_points()

func calculate_frame_points():
	for i in range(0, len(my_frames)):
		var my_frame = my_frames[i]
		var next_frame = Frame.duplicate()
		next_frame.first_throw = 0
		next_frame.second_throw = 0
		var next_next_frame = Frame.duplicate()
		next_next_frame.first_throw = 0
		next_next_frame.second_throw = 0
		if i + 1 < len(my_frames)-1:
			next_frame = my_frames[i+1]
		if i + 2 < len(my_frames)-1:
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

func total_points_for_frame(frame_number):
	var points = 0
	for i in frame_number-1:
		var frame = my_frames[i]
		if frame.points != null:
			points += frame.points
	return points

func print_frame(my_frame):
	print("\n| %s L %s |\n|   %s   |\n" % [str(my_frame.first_throw), str(my_frame.second_throw), str(my_frame.points)])

func draw_frames():
	for i in 10:
		draw_frame(i+1)
	draw_current_frame()

func draw_frame(frame_number):
	var my_frame = my_frames[frame_number-1]
	var first_throw_label = null
	var second_throw_label = null
	var points_label = null
	if frame_number <= 5:
		first_throw_label = get_node("Panel/VBoxContainer/HBoxContainer/AllFrames/VBoxContainer/TopRow/Frame%d/VBoxContainer/HBoxContainer/CenterContainer/Label" % frame_number)
		second_throw_label = get_node("Panel/VBoxContainer/HBoxContainer/AllFrames/VBoxContainer/TopRow/Frame%d/VBoxContainer/HBoxContainer/Panel/CenterContainer/Label" % frame_number)
		points_label = get_node("Panel/VBoxContainer/HBoxContainer/AllFrames/VBoxContainer/TopRow/Frame%d/VBoxContainer/CenterContainer/Label" % frame_number)
	else:
		first_throw_label = get_node("Panel/VBoxContainer/HBoxContainer/AllFrames/VBoxContainer/BottomRow/Frame%d/VBoxContainer/HBoxContainer/CenterContainer/Label" % frame_number)
		second_throw_label = get_node("Panel/VBoxContainer/HBoxContainer/AllFrames/VBoxContainer/BottomRow/Frame%d/VBoxContainer/HBoxContainer/Panel/CenterContainer/Label" % frame_number)
		points_label = get_node("Panel/VBoxContainer/HBoxContainer/AllFrames/VBoxContainer/BottomRow/Frame%d/VBoxContainer/CenterContainer/Label" % frame_number)
	
	first_throw_label.text = ""
	second_throw_label.text = ""
	points_label.text = ""
	
	var frame_total_points = my_frame.points
	if frame_total_points != null:
		frame_total_points += total_points_for_frame(frame_number)
		points_label.text = str(frame_total_points)
	
	if my_frame.first_throw != null:
		if my_frame.first_throw == 10:
			first_throw_label.text = "X"
		else:
			if my_frame.first_throw == 0:
				first_throw_label.text = "-"
			else:
				first_throw_label.text = str(my_frame.first_throw)
	
	if my_frame.second_throw != null:
		if my_frame.first_throw + my_frame.second_throw == 10:
			second_throw_label.text = "/"
		else:
			if my_frame.second_throw == 0:
				second_throw_label.text = "-"
			else:
				second_throw_label.text = str(my_frame.second_throw)

func draw_current_frame():
	if current_frame_number > len(my_frames):
		return
	var my_frame = my_frames[current_frame_number-1]
	var first_throw_label = _current_first_throw_label
	var second_throw_label = _current_second_throw_label
	var points_label = _current_points_label
	
	first_throw_label.text = ""
	second_throw_label.text = ""
	points_label.text = ""
	
	var frame_total_points = my_frame.points
	if frame_total_points != null:
		frame_total_points += total_points_for_frame(current_frame_number)
		points_label.text = str(frame_total_points)
	
	if my_frame.first_throw != null:
		if my_frame.first_throw == 10:
			first_throw_label.text = "X"
		else:
			if my_frame.first_throw == 0:
				first_throw_label.text = "-"
			else:
				first_throw_label.text = str(my_frame.first_throw)
	
	if my_frame.second_throw != null:
		if my_frame.first_throw + my_frame.second_throw == 10:
			second_throw_label.text = "/"
		else:
			if my_frame.second_throw == 0:
				second_throw_label.text = "-"
			else:
				second_throw_label.text = str(my_frame.second_throw)

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
		draw_frames()
	elif frame.second_throw == null:
		frame.second_throw = num_pins
		do_calculations()
		draw_frames()

func next_frame():
	set_current_frame(current_frame_number + 1)

func set_current_frame(frame_num):
	emit_signal("new_frame")
	do_calculations()
	current_frame_number = frame_num
	draw_frames()
	_frame_label.text = "FRAME: %d" % frame_num

func game_is_end():
	var is_end = true
	for frame in my_frames:
		if frame.points == null:
			is_end = false
			break
	return is_end
