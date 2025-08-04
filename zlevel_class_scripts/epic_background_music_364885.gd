extends AudioStreamPlayer2D



	

func _process(delta: float) -> void:
	if GameManager.are_we_playing == true:
		stop()
