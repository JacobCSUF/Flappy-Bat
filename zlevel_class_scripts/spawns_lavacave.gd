class_name lavacave extends Node2D
var rng = RandomNumberGenerator.new()

var spawn_location = 0

var pipe_only_mode_count = 0
@export var spawn_object: PackedScene = preload("res://level2/scenes/lavapipe.tscn")
@export var score_scene: PackedScene = preload("res://scenes/score_point.tscn")
@export var lavafall: PackedScene = preload("res://level2/scenes/lavafall.tscn")
@export var fireball: PackedScene = preload("res://level2/scenes/fireball.tscn")
@export var fireobs: PackedScene = preload("res://level2/scenes/fireobelisk.tscn")
@export var boulder: PackedScene = preload("res://level2/scenes/boulder.tscn")
@export var cage: PackedScene = preload("res://level2/scenes/cage.tscn")
@export var barrel: PackedScene = preload("res://scenes/barrel.tscn")

@export var fruit: PackedScene = preload("res://level1/scenes/ball.tscn")
@export var fan: PackedScene = preload("res://scenes/fanboost.tscn")
@export var boat_cart: PackedScene = preload("res://scenes/boat_cart.tscn")
@export var double_pipe: PackedScene = preload("res://level2/scenes/double_pipe.tscn")
@export var shield: PackedScene= preload("res://scenes/shield.tscn")
func _ready():
	var spawner = spawns_base.new()
	spawn_location = spawner.spawn_location
	

func random_spawn():
	
	# Check if pipe-only mode is active
	if pipe_only_mode_count > 0:
		pipe_only_mode_count -= 1
		var pipe_spawn_type = rng.randi_range(0, 3)
		var x = 0
		if pipe_spawn_type >= 1 :
			x = spawn_pipes()
		else:
			x = spawn_pipe_stairs()

		var score = score_scene.instantiate()
		score.position = Vector2(spawn_location+23, 0)
		add_child(score)

		if x == null:
			return 1
		return x
	else:
		# Roll a 5% chance to activate pipe-only mode for next 5 spawns
		if rng.randf() < 0.04:
			pipe_only_mode_count = 6

		# === TESTING OVERRIDE ===
		# Uncomment one of these to test a specific spawn and comment the rest of the function

		# return spawn_pipes()
		#return spawn_fan()
		# return spawn_fireballs()
		#return spawn_fan_fire()
		# return spawn_cage()
		# return spawn_obelisk()
		#return spawn_pipe_stairs()
		# return spawn_fan_pipe_pairs()
		# return spawn_fan_pipe_trios()
		#return spawn_shooting_fire()
		#return spawn_shield()
		# =========================
		if randi_range(0,50) == 50:
			return spawn_shield()
		var object_type = rng.randi_range(0, 11)
		var lavafall_chance = rng.randi_range(1, 5)
		if lavafall_chance == 1:
			spawn_lavafall()

		var x = 0
		if object_type > 9:
			x = spawn_obelisk()
		elif object_type > 8:
			x = spawn_cage()
		elif object_type > 7:
			x = spawn_fan_fire()
		elif object_type > 6:
			x = spawn_fireballs()
		elif object_type > 5:
			x = spawn_fan()
		elif object_type > 4:
			x = spawn_fan_pipe_pairs()
		elif object_type > 3:
			x = spawn_pipe_stairs()
		elif object_type > 2:
			x = spawn_fan_pipe_trios()
		elif object_type > 1:
			x = spawn_shooting_fire()
		else:
			x = spawn_pipes()

		var score = score_scene.instantiate()
		score.position = Vector2(spawn_location+23, 0)
		add_child(score)

		if x == null:
			return 1
		return x
	
	
func spawn_shield():
	var obj = spawn_object.instantiate()
	var obj2 = spawn_object.instantiate()
	obj.scale.y = -1  # Flips the object upside down
	obj.position = Vector2(spawn_location+100, -215)
	add_child(obj)
		
	obj2.position = Vector2(spawn_location+100, 215)
	add_child(obj2)
	
	var shield_ = shield.instantiate()
	shield_ .position = Vector2(spawn_location+300, -10)
	add_child(shield_ )
	return 4
	
func spawn_shooting_fire():
	var x = randi_range(0, 1)  # Used for flipping most pipes
	var random = randi_range(0, 2)
	var return_number = 2

	# Special case: if random == 2
	if random == 2:
		var double_pipe_ = double_pipe.instantiate()
		double_pipe_.position = Vector2(spawn_location + 250, -20)
		
		# Flip randomly, NOT based on x
		if randi_range(0, 1) == 0:
			double_pipe_.scale.y = -1
		
		add_child(double_pipe_)
		return_number += 2

	elif random == 1:
		var double_pipe_ = double_pipe.instantiate()
		double_pipe_.position = Vector2(spawn_location + 100, -20)
		
		# Flip based on x
		if x == 0:
			double_pipe_.scale.y = -1
		
		add_child(double_pipe_)

	elif random == 0:
		var double_pipe_ = double_pipe.instantiate()
		double_pipe_.position = Vector2(spawn_location + 100, -20)
		if x == 0:
			double_pipe_.scale.y = -1
		add_child(double_pipe_)

		var double_pipe_2 = double_pipe.instantiate()
		double_pipe_2.position = Vector2(spawn_location + 150, -20)
		if x == 0:
			double_pipe_2.scale.y = -1
		add_child(double_pipe_2)
		return_number += 1

	# Common pipe that always spawns
	var base_pipe = double_pipe.instantiate()
	base_pipe.position = Vector2(spawn_location + 50, -20)
	if x == 0:
		base_pipe.scale.y = -1
	add_child(base_pipe)

	return return_number

	
	


func spawn_pipes():
	var offset = randf_range(-90.0,40.0)
	var pipe_type = rng.randi_range(0,10)
	var obj = spawn_object.instantiate()
	var obj2 = spawn_object.instantiate()
	var spawn_pipe = 194
	if pipe_type > 5:
		spawn_pipe = 183
		obj.modulate = Color(0.812, 0.161, 0.267)
		obj2.modulate = Color(0.812, 0.161, 0.267)
			
		if pipe_type > 7:
			var adder = 0
			var adder_vert = 0
			for i in range(2):
				var objd = spawn_object.instantiate()
				var objd2 = spawn_object.instantiate()
		
				objd.modulate = Color(0.812, 0.161, 0.267)
				objd2.modulate = Color(0.812, 0.161, 0.267)
				objd.scale.y = -1  # Flips the object upside down
				objd.position = Vector2(spawn_location+adder, -spawn_pipe + (offset/2.0)+adder_vert)
				add_child(objd)
				objd.get_node("AnimationPlayer").play("redspin")
				objd.get_node("AnimationPlayer").seek(offset/4.0,true)
				objd2.position = Vector2(spawn_location+adder, spawn_pipe + (offset/2.0)+adder_vert)
				add_child(objd2)
				objd2.get_node("AnimationPlayer").play("redspin")
				objd2.get_node("AnimationPlayer").seek(offset/4.0,true)
					
				adder += 180
				adder_vert -= 25
			
			
			return 4
	
	obj.scale.y = -1  # Flips the object upside down
	obj.position = Vector2(spawn_location, -spawn_pipe + offset)
	add_child(obj)
		
	obj2.position = Vector2(spawn_location, spawn_pipe + offset)
	add_child(obj2)
	
func spawn_obelisk():
	var offset = randf_range(5.0,5.0)
	var obelisk = fireobs.instantiate()
	obelisk.position = Vector2(spawn_location+75, 125 + -abs(offset/1.5))
	add_child(obelisk)
	return 2
	
func spawn_cage():
	var offset = randf_range(-15,15)
	var adder = 0
	for i in range(2):
		var cage1 = cage.instantiate()
		cage1.position = Vector2(spawn_location+adder,-30+offset/4)
		add_child(cage1)
		adder += 35
	
	
func spawn_lavafall():
	
	var lavafall_ = lavafall.instantiate()
	lavafall_.position = Vector2(spawn_location + 60, 0 )
	add_child(lavafall_)
	
func spawn_fan():
	var offset = randf_range(-40,20)
	var fan_ = fan.instantiate()
	fan_.autospin = true
	fan_.position = Vector2(spawn_location+15,offset)
	add_child(fan_)
	var obj = spawn_object.instantiate()
	var obj2 = spawn_object.instantiate()
	obj.scale.y = -1  # Flips the object upside down
	obj.position = Vector2(spawn_location+15, -215 + offset)
	add_child(obj)
	obj.get_node("AnimationPlayer").stop()
		
	obj2.position = Vector2(spawn_location+15, 210 + offset)
	add_child(obj2)
	obj2.get_node("AnimationPlayer").stop()
	
	for i in range(6):
		var barrel_ = barrel.instantiate()
		var random_y_offset = rng.randi_range(-25, 20)
		barrel_.position = Vector2(spawn_location +15+ ((i + 1) * 50), offset - 10 + random_y_offset)
		add_child(barrel_)
	return 5
	
func spawn_fireballs():
	var hole = rng.randi_range(3, 8)
	for i in range(12):
		if i in range(hole, hole + 3):
			continue  # Skip 3 fireballs starting from 'hole'
		var fireball_ = fireball.instantiate()
		fireball_.position = Vector2(spawn_location-20, 125 - (25 * i))
		add_child(fireball_)
		var fireball2_ = fireball.instantiate()
		fireball2_.position = Vector2(spawn_location, 125 - (25 * i))
		add_child(fireball2_)
		var fireball3_ = fireball.instantiate()
		fireball3_.position = Vector2(spawn_location+20, 125 - (25 * i))
		add_child(fireball3_)

func spawn_fan_fire():
	var offset = randf_range(0,0)
	var sets_to_spawn = rng.randi_range(1, 3)  # 1 to 3 fans, all part of one set
	var spacing = 340
	var vertical_spacing = 30
	var fireball_range = 250  # Vertical coverage from center

	var y_shift = rng.randi_range(-70, 25)  # Apply to the whole set
	var offset_y = offset + y_shift

	for set_index in range(sets_to_spawn):
		var base_x = spawn_location + set_index * spacing

		# Fan
		var fan_ = fan.instantiate()
		fan_.autospin = true
		fan_.position = Vector2(base_x + 23, offset_y + 2)
		add_child(fan_)

		# Vertical fireballs (left of fan)
		var vertical_steps = int((fireball_range * 2) / vertical_spacing) + 1
		var half_steps = int(vertical_steps / 2.0)

		for i in range(-half_steps, half_steps + 1):
			var y_pos = offset_y + (vertical_spacing * i)
			if abs(y_pos - offset_y) > 30:
				var fireball_ = fireball.instantiate()
				fireball_.position = Vector2(base_x + 60, y_pos)
				add_child(fireball_)

		# Horizontal fireballs (to the right)
		for i in range(11):
			var x_pos = base_x + 60 + (25 * i)

			var fireball_top = fireball.instantiate()
			fireball_top.position = Vector2(x_pos, offset_y + 42)
			add_child(fireball_top)

			var fireball_bottom = fireball.instantiate()
			fireball_bottom.position = Vector2(x_pos, offset_y - 36)
			add_child(fireball_bottom)
	if sets_to_spawn ==1:
		return 5
	return (sets_to_spawn * 4)



func spawn_fan_pipe_pairs():
	var spacing = 300 # Wider spacing between each pair
	var start_x = spawn_location

	for i in range(3):
		var is_top = rng.randi_range(0, 1) == 1  # true = pipe on top

		var pipe = spawn_object.instantiate()
		var fan_ = fan.instantiate()
		fan_.autospin = true

		var base_x = start_x + i * spacing
		var pipe_y = -160 if is_top else 120
		var fan_y = pipe_y + (220 if is_top else -220)  # fan is on opposite side with padding

		# Flip the pipe if it's on top
		pipe.scale.y = -1 if is_top else 1

		pipe.position = Vector2(base_x, pipe_y)
		fan_.position = Vector2(base_x, fan_y)

		add_child(pipe)
		add_child(fan_)
	return 10
	

func spawn_pipe_stairs():
	var x = rng.randi_range(0, 2)  # 0 = 1 pair, 1 = 2 pairs, 2 = 3 pairs
	var stair_count = [1, 3, 5].pick_random()

	var return_val = 0

	if x == 0:
		# 1 pair of pipes per stair
		for i in range(stair_count):
			var obj = spawn_object.instantiate()
			var obj2 = spawn_object.instantiate()
			obj.modulate = Color.YELLOW
			obj2.modulate = Color.YELLOW
			obj.scale.y = -1
			obj.position = Vector2(spawn_location + (i * 185)+20, -172 + (i * -30))
			add_child(obj)
			obj.get_node("AnimationPlayer").stop()
			obj2.position = Vector2(spawn_location + (i * 185)+20, 192 + (i * -30))
			add_child(obj2)
			obj2.get_node("AnimationPlayer").stop()

			# Spawn orb(s) if last stair
			if stair_count == 5 and i == 4:
				var orb = fruit.instantiate()
				orb.position = Vector2(spawn_location + (i * 185)+20, 0 + (i * -30))
				add_child(orb)

		return_val = 1 if stair_count == 1 else (10 if stair_count == 5 else 6)

	elif x == 1:
		# 2 pairs of pipes per stair
		for i in range(stair_count):
			for j in range(2):
				var obj = spawn_object.instantiate()
				var obj2 = spawn_object.instantiate()
				obj.modulate = Color.YELLOW
				obj2.modulate = Color.YELLOW
				var x_offset = (i * 180) + (j * 50)+20
				obj.scale.y = -1
				obj.position = Vector2(spawn_location + x_offset, -170 + (i * -25))
				add_child(obj)
				obj.get_node("AnimationPlayer").stop()
				obj2.position = Vector2(spawn_location + x_offset, 190 + (i * -25))
				add_child(obj2)
				obj2.get_node("AnimationPlayer").stop()

			# Spawn orb(s) if last stair
			if stair_count == 5 and i == 4:
				for n in range(2):
					var orb = fruit.instantiate()
					orb.position = Vector2(spawn_location + (i * 180) +20+ (n * 50), 0 + (i * -25))
					add_child(orb)

		return_val = 2 if stair_count == 1 else (11 if stair_count == 5 else 7)
		
	elif x == 2:
		# 3 pairs of pipes per stair
		for i in range(stair_count):
			for j in range(3):
				var obj = spawn_object.instantiate()
				var obj2 = spawn_object.instantiate()
				obj.modulate = Color.YELLOW
				obj2.modulate = Color.YELLOW
				var x_offset = (i * 205) + (j * 45) + 20
				obj.scale.y = -1
				obj.position = Vector2(spawn_location + x_offset, -174 + (i * -20))
				add_child(obj)
				obj.get_node("AnimationPlayer").stop()
				obj2.position = Vector2(spawn_location + x_offset, 194 + (i * -20))
				add_child(obj2)
				obj2.get_node("AnimationPlayer").stop()

			# Spawn orb(s) if last stair
			if stair_count == 5 and i == 4:
				for n in range(3):
					var orb = fruit.instantiate()
					var orb_x = (i * 205) + (n * 45)
					orb.position = Vector2(spawn_location + orb_x+20, 0 + (i * -20))
					add_child(orb)
		
		return_val = 2 if stair_count == 1 else (11 if stair_count == 5 else 7)
	
	return return_val


func spawn_fan_pipe_trios():
	var offset = randi_range(-50,30)
	var spacing = 200
	var start_x = spawn_location
	var sets_to_spawn = rng.randi_range(3, 5)

	var pipe_distance = 215
	var center_y_variation = 50
	var buffer_bottom = 60
	var buffer_top = 10

	var max_center_y = offset + 300 - pipe_distance - buffer_bottom
	var min_center_y = offset - 300 + pipe_distance + buffer_top

	var center_y = rng.randi_range(min_center_y, max_center_y)

	for i in range(sets_to_spawn):
		var base_x = start_x + i * spacing

		var fan_ = fan.instantiate()
		fan_.autospin = true
		fan_.position = Vector2(base_x - 5, center_y)
		add_child(fan_)

		var obj_top = spawn_object.instantiate()
		obj_top.scale.y = -1
		obj_top.position = Vector2(base_x, center_y - pipe_distance)
		add_child(obj_top)
		obj_top.get_node("AnimationPlayer").stop()

		var obj_bottom = spawn_object.instantiate()
		obj_bottom.position = Vector2(base_x, center_y + pipe_distance)
		add_child(obj_bottom)
		obj_bottom.get_node("AnimationPlayer").stop()

		center_y += rng.randi_range(-center_y_variation, center_y_variation)
		center_y = clamp(center_y, min_center_y, max_center_y)

	# Spawn fruits after pipes and fans
	var fruits_to_spawn = rng.randi_range(2, 6)  # twice as many fruits now
	for i in range(fruits_to_spawn):
		var fruit_instance = fruit.instantiate()
		var fruit_x = start_x + sets_to_spawn * spacing + 45 + i * 60  # further right
		var fruit_y = offset + rng.randi_range(-70, 50)
		fruit_instance.position = Vector2(fruit_x, fruit_y) 
		add_child(fruit_instance)

	return sets_to_spawn * 3
