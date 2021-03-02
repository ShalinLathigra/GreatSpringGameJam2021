extends KinematicBody2D

# References:
#	https://core.ac.uk/download/pdf/80991297.pdf
#	https://www.instructables.com/Advanced-Platformer-Movement/
#	http://devmag.org.za/2012/07/19/13-more-tips-for-making-a-fun-platformer/

# I want to include:
	# Coyote Time
	# Jump Buffering
	# Climbing should be initiated by pressing up or down
	# Jump buffering: Track time of requested jump, if it's really close, then jump.
	# 


# Basic Movement:
export (float) var max_vel_x = 300
export (float) var accel_time = 0.5
export (float) var decel_time = 0.1
onready var vel_x : float  = 0.0

export (int) var GRAVITY = 1500	# accelerate fall to 980 pixels per second
export (float) var jump_force = -400
export (float) var jump_time = 0.5
export (float) var max_vel_y = 300
export (float) var wall_slide_modifier = 0.25
export (int) var jump_buffer = 100	# .1 s for jump buffer
export (int) var coyote_time = 100	# .1 s for jump buffer

onready var vel_y : float  = 0.0
onready var jumping : bool = false
onready var can_jump : bool = false

onready var jump_buffered : bool = false
onready var time_of_last_space : int = OS.get_ticks_msec()
onready var time_last_grounded : int = 0
	
onready var climbing = false

func _physics_process(delta):
	# Get Input
	process_x_movement()
	process_jump_input()
	
	# Need to handle the Climbing case
	# Basically, if you enter one of these areas and press up/down, Things that visually say "Climb me harder"
	#	climbing is set to true, don't fall from gravity, allow jumping
	
	# Further process y information
	if not (jumping or climbing) and not is_on_floor():
		var fall_speed = GRAVITY
		if is_on_wall():	# Or was just on wall
			fall_speed *= wall_slide_modifier
		vel_y += fall_speed * delta
		
	var move_vel = Vector2(vel_x, vel_y)
	var collision = move_and_slide(move_vel, Vector2.UP)
	if (collision):
		print (collision)
		pass


func process_jump_input():
	var j = Input.is_action_just_pressed(" ")
	
	if (j):	# Jump buffering
		time_of_last_space = OS.get_ticks_msec()
		jump_buffered = true
	
	if (is_on_floor()):
		time_last_grounded = OS.get_ticks_msec()
	
	var grounded_ish = time_last_grounded + coyote_time > OS.get_ticks_msec()
	
	can_jump = not jumping and grounded_ish
	var should_jump = jump_buffered	and grounded_ish and (time_of_last_space + jump_buffer > OS.get_ticks_msec())
	# Need to also determine when the last time you were able to jump is.
	if j and can_jump or should_jump: # and can jump
		# set all the jump related variables, take control from gravity
		jumping = true
		jump_buffered = false
		vel_y = jump_force
		$Tween.stop(self, "vel_y")
		$Tween.interpolate_property(self, "vel_y", vel_y, 0.0, jump_time, Tween.TRANS_QUAD)
		$Tween.start()
	elif Input.is_action_just_released(" "):
		# Set jump bool to false, let gravity take over
		jumping = false
		vel_y = max(0.0, vel_y)
		$Tween.stop(self, "vel_y")
	pass
	
func process_x_movement():
	# Left/Right Key Detection
	var dir = 0
	var l = Input.is_action_just_pressed("L")
	var r = Input.is_action_just_pressed("R")
	if l or r:
		# Accelerate towards desired velocity
		dir = float(l) * -1.0 + float(r) * 1.0
		var speed_percent = 0.0
		if (l):
			speed_percent = (max_vel_x - vel_x) / max_vel_x
		else:
			speed_percent = abs(-max_vel_x - vel_x) / max_vel_x
		
		$Tween.stop(self, "vel_x")
		$Tween.interpolate_property(self, "vel_x", vel_x, dir * max_vel_x, accel_time * speed_percent, Tween.TRANS_CIRC, Tween.EASE_OUT)
		$Tween.start()
		
	elif Input.is_action_just_released("L") or  Input.is_action_just_released("R"):
		if not (Input.is_action_pressed("L") or  Input.is_action_pressed("R")):
			# Decelerate towards 0 if released and not still pressed
			var speed_percent = abs(vel_x) / max_vel_x
			$Tween.stop(self, "vel_x")
			$Tween.interpolate_property(self, "vel_x", vel_x, 0.0, accel_time * speed_percent, Tween.TRANS_CIRC, Tween.EASE_OUT)


func _on_Tween_tween_completed(_object, key):
	if (key == ":vel_y"):
		jumping = false
		vel_y = max(0.0, vel_y)
		$Tween.stop(self, key)
	pass # Replace with function body.
