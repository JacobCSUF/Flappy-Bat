extends CharacterBody2D
func _process(_delta: float) -> void:
	
	
	var despawn = MovementManager.despawn_position 
	if position.x < despawn:
		queue_free()
