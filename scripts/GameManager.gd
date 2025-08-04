extends Node

signal taco_called(score)  # Step 1: Define the signal
signal sublevel_enter(level)

var current_level: String = ''       # or use SceneTree if you know the type
var score: int = 0
var is_boat: bool = false
var screenshake: bool = false
var crystal_balls: int = 0
var are_we_playing = false
var paused = true

var prev_score = 0
var has_shield = false

func taco(hi):
	
	score += 1
	emit_signal("taco_called", score)  # Step 2: Emit signal
	
func new_sublevel_entered(level):
	emit_signal("sublevel_enter",level)
	
