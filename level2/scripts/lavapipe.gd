extends "res://scripts/OBJECT_MOVEMENT.gd"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()
var animation_offset = rng.randf_range(0,4)




func _ready():
	
	super()
	animation_player.play("new_animation")
	animation_player.seek(animation_offset, true)
