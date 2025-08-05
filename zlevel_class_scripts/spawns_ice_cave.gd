class_name ice_cave extends Node2D

@export var pipe: PackedScene  = preload("res://Ice Level/scenes/ice_pipe.tscn")
@export var snow_pipe: PackedScene  = preload("res://Ice Level/scenes/snow_pipe.tscn")

var rng = RandomNumberGenerator.new()
var spawn_location = 0



func _ready():
	var spawner = spawns_base.new()
	spawn_location = spawner.spawn_location

func random_spawn():
	#var x =spawn_pipe()
	var x = spawn_snow_pipe()
	return x
	
func spawn_pipe():
	var x = randi_range(0,1)
	var obj = pipe.instantiate()
	var loc = 1
	if x == 1:
		loc = -1
		obj.scale.y = -1  # Flips the object upside down
	obj.position = Vector2(spawn_location, 140* loc)
	add_child(obj)
		
	return 1
	
	
func spawn_snow_pipe():
	var snow_pipe_ = snow_pipe.instantiate()
	snow_pipe_.position = Vector2(spawn_location, 0)
	add_child(snow_pipe_)
	
	return 4
