extends Node

var is_ready = false


signal lava_jump_animation()
signal lava_fall_animation()
signal boat_burning()
signal bat_nervous()
signal shield_ready()
signal break_shield()

func play_animation():
	pass


func boat_lava_jump():
	emit_signal("lava_jump_animation")

func boat_lava_fall():
	emit_signal("lava_fall_animation")

func boat_is_burning():
	emit_signal("boat_burning")

func nervous_bat():
	emit_signal("bat_nervous")

func ready_shield():
	emit_signal("shield_ready")
	
func shield_break():
	emit_signal("break_shield")
