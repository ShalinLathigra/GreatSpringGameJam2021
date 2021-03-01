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
onready var vel_x = 0.0
export (float) var max_vel_x = 100
export (float) var accel_time = 0.5
export (float) var decel_time = 0.125

export (int) var GRAVITY = 980	# accelerate fall to 980 pixels per second
onready var vel_y = 0.0
export (float) var jump_force = -500
export (float) var jump_time = 2.0

func _physics_process(_delta):
	# Get Input
	process_x_movement()
	process_jump_input()
	
	
	var move_vel = Vector2(vel_x, vel_y)
	move_and_slide(move_vel, Vector2.UP)
	pass

func process_jump_input():
	var j = Input.is_action_just_pressed(" ")
	if j: # and can jump
		# set all the jump variables, take control from gravity
		$Tween.stop(self, "vel_y")
		$Tween.interpolate_property(self, "vel_y", 0.0, jump_force, jump_time, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		$Tween.start()
		
	elif Input.is_action_just_released(" "):
		# Set jump variables to false, let gravity take over
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
