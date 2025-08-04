extends "res://scripts/OBJECT_MOVEMENT.gd"
var rng = RandomNumberGenerator.new()
@onready var killzone: Area2D = $AnimatedSprite2D/Killzone

var animation_offset = rng.randf_range(0,3)

func _ready():
	super()
	$chainfall.play("chainfall")
	$chainfall.seek(animation_offset, true)
