extends Node2D
@export var base_game_speed = 165
@export var base_wait_time := 0.57
var time_accumulator := 0.0
var previous_game_speed = 165
var rng = RandomNumberGenerator.new()
var offset = 0.0


const LEVEL_2 = preload("res://level2/scenes/level_2.tscn")
const ICE_LEVEL = preload("res://Ice Level/scenes/ice_level.tscn")
var yuh = LEVEL_2.instantiate()
#var buh = ICE_LEVEL.instantiate()

var level = true
var first = true


func _process(delta: float) -> void:
	if first:
		if GameManager.are_we_playing:
			GameManager.current_level = 'lavacave'
			add_child(yuh)
			first = false
			return
		return
	if Input.is_action_just_pressed("ui_accept"):
		GameManager.paused = false
	if GameManager.paused:
		return
	
	if MovementManager.game_speed <= 0:
		MovementManager.game_speed = 165
		return

	var current_game_speed = MovementManager.game_speed
	var current_wait_time = (base_game_speed * base_wait_time) / current_game_speed

	if previous_game_speed != current_game_speed:
		var old_wait_time = (base_game_speed * base_wait_time) / previous_game_speed
		time_accumulator *= current_wait_time / old_wait_time

	time_accumulator += delta

	if time_accumulator >= current_wait_time:
		time_accumulator = 0
		if level:
			yuh.spawn()
		

	previous_game_speed = current_game_speed
