class_name level2
extends Node2D

@export var lava_intro_duration: int = 3  # How many lava spawns before boat starts
@export var boat_section_length: int = 10  # How many boat spawns before lava resumes

var lava_level = preload("res://zlevel_class_scripts/spawns_lavacave.gd")
var boat_level = preload("res://zlevel_class_scripts/spawns_boat_ride.gd")

@onready var cave_with_pipes: Sprite2D = $background/CaveWithPipes
@onready var lavaground: AnimatedSprite2D = $background/Parallax2D/lavaground

@onready var collision_shape_2d: CollisionShape2D = $"boat collision/CollisionShape2D"

@onready var lavacavetheme: AudioStreamPlayer2D = $sounds/LAVACAVETHEME
@onready var label: Label = $Label
@onready var boatlight: PointLight2D = $boatlight
@onready var previous_score: Label = $"Previous Score"
@onready var boing_spring_mouth_harp_04_20_13_4_103346: AudioStreamPlayer2D = $"Boing-spring-mouth-harp-04-20-13-4-103346"
@onready var instructions: Label = $Instructions

var skip = false
var skip_factor = 0

var bob = true

var lava_level_ = lava_level.new()
var boat_level_ = boat_level.new()
var cave_time = 0
var post_boat_skip_counter = -1  # -1 means not in skip mode
var _transition_tween = null

func _ready() -> void:
	previous_score.text = "Prev: %d" % GameManager.prev_score
	GameManager.connect("taco_called", Callable(self, "_on_taco_called"))
	GameManager.connect("sublevel_enter", Callable(self, "_on_sublevel_enter"))
	add_child(lava_level_)
	add_child(boat_level_)
	lava_intro_duration = randi_range(10,40)
	boat_section_length = randi_range(20,30)
func spawn():
	if skip_factor != 0:
		skip_factor -= 1
		return

	var boat_start = lava_intro_duration
	var boat_end = lava_intro_duration + boat_section_length

	# After boat section ends, begin skipping and reverse transition
	if cave_time >= boat_end:
		if post_boat_skip_counter == -1:
			post_boat_skip_counter = 0

		if post_boat_skip_counter < 5:
			post_boat_skip_counter += 1
			return
		elif post_boat_skip_counter == 5:
			boat_level_.transition_to_flying()
			reverse_boat_transition()
			boing_spring_mouth_harp_04_20_13_4_103346.play()
			post_boat_skip_counter += 1

	if cave_time < boat_start or cave_time >= boat_end:
		spawn_lava()
	else:
		if cave_time == boat_end - 4:
			print('hi  ')
			AnimationManager.boat_is_burning()
			
		spawn_boat()

	cave_time += 1
	instructions.visible = false
func spawn_lava():
	skip_factor = lava_level_.random_spawn()
	boatlight.visible = false

func spawn_boat():
	boatlight.visible = true
	boatlight.energy = 0.0

	var tween = create_tween()
	tween.tween_property(boatlight, "energy", 0.85, 4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(cave_with_pipes, "modulate", Color(0.3, 0.2, 0.35, 1.0), 4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	skip_factor = boat_level_.random_spawn()

func reverse_boat_transition():
	if _transition_tween != null and _transition_tween.is_valid():
		_transition_tween.kill()

	if not lavacavetheme.playing:
		lavacavetheme.volume_db = -30
		lavacavetheme.play()

	_transition_tween = create_tween()
	_transition_tween.tween_property(lavacavetheme, "volume_db", -16, 3.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)

	_transition_tween.tween_property(cave_with_pipes, "modulate", Color(1, 1, 1, 1), 3.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	_transition_tween.tween_property(boatlight, "energy", 0.0, 2.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _on_sublevel_enter(level):
	if level == "lavaboat":
		var tween = create_tween()
		tween.tween_property(lavacavetheme, "volume_db", -30, 3.0)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		tween.tween_callback(Callable(lavacavetheme, "stop"))

func _on_taco_called(score):
	label.text = "Score: %d" % score
