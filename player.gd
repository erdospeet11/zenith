extends CharacterBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera_3d: Camera3D = $CameraPivot/Camera3D
@onready var arm: Node3D = $CameraPivot/Camera3D/Sketchfab_Scene

var movement_speed = 5.0
var mouse_sensitivity = 0.002

var jump_velocity = 4.5
var jump_count = 1


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
		
	var animationplayer : AnimationPlayer = arm.get_node("AnimationPlayer")
	if velocity != Vector3.ZERO:
		if Input.is_action_pressed("movement"):
			animationplayer.play("axe_RUN")
		else:
			animationplayer.play("axe_WALK")
	else:
		animationplayer.play("axe_IDLE")
	
func _process(_delta: float) -> void:
	print(velocity)
	
	if Input.is_action_pressed("attack"):
		var animationplayer : AnimationPlayer = arm.get_node("AnimationPlayer")
		
		animationplayer.play("axe_ATK1(no hit)")
	
	if Input.is_action_pressed("jump"):
			var animationplayer : AnimationPlayer = arm.get_node("AnimationPlayer")
			
			animationplayer.play("axe_JUMP")

	if Input.is_action_pressed("movement"):
		print()
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$CameraPivot/Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$CameraPivot/Camera3D.rotation.x = clampf($CameraPivot/Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
