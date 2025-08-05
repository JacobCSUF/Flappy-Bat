class_name ice_level
extends Node2D

var ice_spawns = preload("res://zlevel_class_scripts/spawns_ice_cave.gd")

var ice_spawns_ = ice_spawns.new()
var skip_factor = 1
func _ready() -> void:
	MovementManager.change_movement("roll")
	add_child(ice_spawns_)


func spawn():
	if skip_factor != 0:
		skip_factor -= 1
		return
	skip_factor= ice_spawns_.random_spawn()
