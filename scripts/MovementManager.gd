extends Node

signal speed_changed(speed)
signal movement_changed(type)

#base speed should be 165
var game_speed = 165
var is_spinning = false
var fly_timer = .40
var auto_spin = false
var despawn_position = -500
var timer_array = []


func change_game_speed_always(speed):
	game_speed += speed
	emit_signal("speed_changed", game_speed)

func change_speed(speed: float, speed_time: float, flight_time: float, reuse_timer := false) -> void:
	game_speed += speed
	fly_timer += flight_time
	emit_signal("speed_changed", game_speed)

	var temp_timer: Timer

	if reuse_timer and timer_array.size() > 0:
		# Extend the most recent timer instead of creating a new one
		temp_timer = timer_array[timer_array.size() - 1]
		temp_timer.wait_time += speed_time

		# Restart the timer with the new total wait time
		if temp_timer.is_stopped():
			temp_timer.start()
		else:
			temp_timer.stop()
			temp_timer.start()
	else:
		# Create a new timer
		temp_timer = Timer.new()
		add_child(temp_timer)
		temp_timer.one_shot = true
		temp_timer.wait_time = speed_time
		temp_timer.start()
		timer_array.append(temp_timer)

	await temp_timer.timeout  # Wait before decreasing speed

	game_speed -= speed
	emit_signal("speed_changed", game_speed)

	timer_array.erase(temp_timer)
	temp_timer.queue_free()

	
func change_movement(movement_type):
	emit_signal("movement_changed", movement_type)
		
func reset_game():
	for timer in timer_array:
		if timer:  # Make sure timer is not null
			timer.stop()
			timer.queue_free()
	timer_array.clear()
