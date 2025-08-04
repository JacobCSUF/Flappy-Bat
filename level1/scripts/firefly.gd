extends CharacterBody2D

@export var move_speed: float = 50.0
@export var change_direction_min: float = 0.5
@export var change_direction_max: float = 2.0

var direction: Vector2 = Vector2.LEFT
var rng = RandomNumberGenerator.new()
var timer: Timer

func _ready():
	rng.randomize()
	_update_movement_direction()

	timer = Timer.new()
	timer.one_shot = false
	timer.autostart = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

	_set_random_timer()

func _physics_process(delta):
	# Prevent going below y = 144
	if position.y + direction.y * delta > 144:
		direction.y = 0

	velocity = direction
	move_and_slide()

	if position.x < -450 or position.y < -150:
		queue_free()

func _update_movement_direction():
	var horizontal_offset = rng.randf_range(-20, 10)  # wiggle left/right but mostly left
	var final_horizontal = -move_speed + horizontal_offset
	var vertical_speed = rng.randf_range(-60, 5)  # vertical up/down movement

	# Clamp horizontal so it doesn't move too far right
	final_horizontal = clamp(final_horizontal, -move_speed - 20, 10)

	direction = Vector2(final_horizontal, vertical_speed)

func _set_random_timer():
	timer.wait_time = rng.randf_range(change_direction_min, change_direction_max)
	timer.start()

func _on_timer_timeout():
	_update_movement_direction()
	_set_random_timer()
