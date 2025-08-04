extends CharacterBody2D

var SPEED: float = 0
var despawn: int = 0
var speed_multiplier := 1.0
func _ready():
	
	# Set initial speed
	SPEED = MovementManager.game_speed

	# Connect to the signal with a callable (Godot 4 style)
	MovementManager.connect("speed_changed", Callable(self, "_on_speed_changed"))

func _on_speed_changed(new_speed: float) -> void:    
	
	SPEED = new_speed
	
func _process(_delta: float) -> void:
	
	velocity.x = -SPEED * speed_multiplier
	move_and_slide()
	despawn = MovementManager.despawn_position 
	if position.x < despawn:
		queue_free()
