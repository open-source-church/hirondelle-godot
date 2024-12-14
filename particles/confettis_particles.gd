@tool
extends Node2D
class_name HConfettisParticles

const CONFETTIS_PARTICLES_PART = preload("res://particles/confettis_particles_part.tscn")

@export var dothings := false:
	set(val): 
		if not is_node_ready(): return
		create()

func create(amount_per_color: int = 50, colors = [], variation := 0.1, scale_min := 5, scale_max := 12, speed := 1.0):
	if not colors.size():
		colors = [Color.RED, Color.BLUE, Color.YELLOW]
	for c in colors:
		instantiate_confettis(amount_per_color, c, variation, scale_min, scale_max, speed)
		var p2 = instantiate_confettis(amount_per_color, c, variation, scale_min, scale_max, speed)
		p2.position.x = DisplayServer.window_get_size().x - p2.position.x
		p2.rotation_degrees = -90

func instantiate_confettis(amount_per_color, color, variation, scale_min, scale_max, speed) -> GPUParticles2D:
	var p1 = CONFETTIS_PARTICLES_PART.instantiate()
	add_child(p1)
	
	p1.process_material.color = color
	p1.amount = amount_per_color
	p1.process_material.hue_variation_min = - variation
	p1.process_material.hue_variation_max = + variation
	p1.process_material.scale_min = scale_min / 32.0
	p1.process_material.scale_max = scale_max / 32.0
	p1.speed_scale = speed
	p1.one_shot = true
	
	if randi() % 2 == 0:
		p1.process_material.particle_flag_align_y = true
	else:
		p1.process_material.particle_flag_disable_z = true
	p1.finished.connect(p1.queue_free)
	p1.emitting = true
	return p1
