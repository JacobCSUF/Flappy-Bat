class_name boatride extends Node2D

var rng = RandomNumberGenerator.new()
var first = true
var firstE = true
var spawn_location = 0

@export var score_scene: PackedScene = preload("res://scenes/score_point.tscn")
@export var lavafall: PackedScene = preload("res://level2/scenes/lavafall.tscn")
@export var boulder: PackedScene = preload("res://level2/scenes/boulder.tscn")
@export var barrel: PackedScene = preload("res://scenes/barrel.tscn")
@export var fruit: PackedScene = preload("res://scenes/fruit.tscn")
@export var fan: PackedScene = preload("res://scenes/fanboost.tscn")
@export var boat_cart: PackedScene = preload("res://scenes/boat_cart.tscn")
@export var spike: PackedScene = preload("res://level2/scenes/spike.tscn")
@export var lava_crystal: PackedScene = preload("res://level2/scenes/lavacrystal.tscn")
@export var ball: PackedScene = preload("res://level1/scenes/ball.tscn")
@export var red_fire_fly: PackedScene = preload("res://level1/scenes/firefly.tscn")



func _ready():
	var spawner = spawns_base.new()
	spawn_location = spawner.spawn_location



func transition_to_flying():
	MovementManager.change_movement("flying")






func random_spawn():
	if first:
		first = false
		GameManager.new_sublevel_entered('lavaboat')
		return 4

	if firstE:
		firstE = false
		spawn_boat_cart()
		spawn_spike()
		return 4


	# === TESTING OVERRIDE ===
	# Uncomment one of the following lines to test only a specific spawn:

	# return spawn_boat_boulder()
	# return spawn_spike()
	# return spawn_lava_crystal()
	# return spawn_crystal_and_spike()
	# return spawn_boost_spike_orbs()
	# return spawn_spike_then_boulder()
	# return spawn_boosts_and_big_rocks()
	# ========================


	var x
	var spawn_type = rng.randi_range(0, 12)
	spawn_firefly()

	match spawn_type:
		
		1:
			x = spawn_boat_boulder()
		2:
			x = spawn_spike()
		3:
			x = spawn_lava_crystal()
		4:
			x = spawn_crystal_and_spike()
		5:
			x = spawn_boost_spike_orbs()
		6:
			x = spawn_spike_then_boulder()
		8:
			x = spawn_boat_boulder()
		9: 
			x = spawn_boosts_and_big_rocks()
		
		_: 
			x = spawn_boat_boulder()
	var score = score_scene.instantiate()
	score.position = Vector2(spawn_location+23,0)
	add_child(score)
	if x == null:
		x = 0
	return x

func spawn_crystal_and_spike():
	var lava_crystal_ = lava_crystal.instantiate()
	lava_crystal_.position = Vector2(spawn_location, 105 )
	add_child(lava_crystal_)
	var ball_ = ball.instantiate()
	ball_.position = Vector2(spawn_location - 14, -30 )
	add_child(ball_)
	var spike_ = spike.instantiate()
	spike_.position = Vector2(spawn_location, -190 )
	add_child(spike_)
	return 2

func spawn_boat_cart():
	var boat = boat_cart.instantiate()
	boat.position = Vector2(spawn_location - 75, 125 )
	add_child(boat)

func spawn_lava_crystal():
	var crystal_type = rng.randi_range(0, 1)
	if crystal_type == 0:
		var lava_crystal_ = lava_crystal.instantiate()
		lava_crystal_.position = Vector2(spawn_location, 105 )
		add_child(lava_crystal_)
		return 2
	if crystal_type == 1:
		for i in range(2):
			var lava_crystal_ = lava_crystal.instantiate()
			lava_crystal_.position = Vector2(spawn_location + (i * 80), 105 )
			add_child(lava_crystal_)
		return 3

func spawn_spike():
	var spike_ = spike.instantiate()
	spike_.position = Vector2(spawn_location, -55 )
	add_child(spike_)
	return 1

func spawn_boat_boulder():
	var boulder_type = rng.randi_range(0, 3)

	if boulder_type == 0:
		var boulder_ = boulder.instantiate()
		boulder_.scale = Vector2(1.2, 1.2)
		boulder_.position = Vector2(spawn_location+25, 110)
		add_child(boulder_)
		return 3

	elif boulder_type == 1:
		var boulder_ = boulder.instantiate()
		boulder_.scale = Vector2(0.5, 0.5)
		boulder_.position = Vector2(spawn_location, 115)
		add_child(boulder_)
		var boulder2_ = boulder.instantiate()
		boulder2_.scale = Vector2(0.5, 0.5)
		boulder2_.position = Vector2(spawn_location + 260, 115)
		add_child(boulder2_)
		return 6

	elif boulder_type == 2:
		for i in range(1, 6):
			var boulder_ = boulder.instantiate()
			boulder_.scale = Vector2(0.3, 0.3)
			boulder_.position = Vector2(spawn_location + (i * 43), 130)
			add_child(boulder_)
			if i != 3:
				boulder_.get_node("bouldernoises").stop()
		return 4

	elif boulder_type == 3:
		var fan_ = fan.instantiate()
		fan_.autospin = true
		fan_.position = Vector2(spawn_location, 105)
		add_child(fan_)
		for i in range(1, 3):
			var boulder_ = boulder.instantiate()
			boulder_.scale = Vector2(0.8, 0.8)
			boulder_.position = Vector2(180 + spawn_location + (i * 125), 100)
			add_child(boulder_)
		return 7

func spawn_firefly():
	for i in range(5):
		var randommm = rng.randi_range(-300, 450)
		var taco = rng.randi_range(10, 50)
		var ff = red_fire_fly.instantiate()
		ff.position = Vector2(randommm, 149 - taco)
		add_child(ff)
		var ff2 = red_fire_fly.instantiate()
		ff2.position = Vector2(randommm, 149 - taco)
		add_child(ff2)

# 🆕 BOOST → SPIKES → BOOST → ORBS
func spawn_boost_spike_orbs():
	var fan1 = fan.instantiate()
	fan1.autospin = true
	fan1.position = Vector2(spawn_location, 105)
	add_child(fan1)

	for i in range(3):
		var spike_ = spike.instantiate()
		spike_.position = Vector2(spawn_location + 60 + (i * 120), -80)
		add_child(spike_)

	var fan2 = fan.instantiate()
	fan2.autospin = true
	fan2.position = Vector2(spawn_location + 250, 105)
	add_child(fan2)

	for i in range(5):
		var orb = ball.instantiate()
		orb.position = Vector2(spawn_location + 350 + (i * 40), 95)  # 50 + 30 = 80
		add_child(orb)

	return 8

# 🆕 SPIKE → BIG BOULDER
func spawn_spike_then_boulder():
	var spike_ = spike.instantiate()
	spike_.position = Vector2(spawn_location + 20, -55)
	add_child(spike_)

	var boulder_ = boulder.instantiate()
	boulder_.scale = Vector2(1.3, 1.3)
	boulder_.position = Vector2(spawn_location + 188, 120)
	add_child(boulder_)

	return 5
	
	
func spawn_boosts_and_big_rocks():
	# Spawn 3 boosts close to each other
	for i in range(3):
		var fan_ = fan.instantiate()
		fan_.autospin = true
		fan_.position = Vector2(spawn_location + (i * 50)-30, 105)  # 70 pixels apart horizontally
		add_child(fan_)

	# Spawn 3 big boulders spaced for jumping
	for i in range(3):
		var boulder_ = boulder.instantiate()
		boulder_.scale = Vector2(1.1, 1.1)  # Bigger size for "big big" rocks
		boulder_.position = Vector2(spawn_location + 480 + (i * 155), 120)  # spaced 200 pixels apart
		add_child(boulder_)
	return 11  
