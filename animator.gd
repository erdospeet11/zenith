extends Node3D

@onready var animationplayer : AnimationPlayer = $Sketchfab_Scene/AnimationPlayer

var animation_queue: Array[String] = []
var current_animation : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if animation_queue.size() > 0:
		current_animation = animation_queue.pop_front()
		animationplayer.play(current_animation)
	else:
		animationplayer.play("axe_IDLE")
