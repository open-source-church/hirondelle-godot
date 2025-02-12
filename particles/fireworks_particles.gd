@tool
extends Node2D
class_name HFireworksParticles

@onready var trails: GPUParticles2D = %Trails
@onready var explosion: GPUParticles2D = %Explosion

@export var emitting := false:
	set(val): 
		if not is_node_ready(): await ready
		trails.emitting = val
	get(): 
		return trails.emitting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trails.process_material.sub_emitter_amount_at_end = 100
	trails.finished.connect(func (): emitting = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
