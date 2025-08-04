extends "res://scripts/OBJECT_MOVEMENT.gd"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()
var animation_offset = rng.randf_range(1,10)


func _ready():
	
	super()
	$AnimationPlayer.play("pipemove")
	$AnimationPlayer.seek(animation_offset/10, true)
