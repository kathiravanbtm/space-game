extends CharacterBody2D
	
const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const BULLET_SCENE = preload("res://scenes/player_bullet.tscn") #
const SPRITE_OFFSET_X = 16 # Set this to half the width difference if your sprite is off-center

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_spawn_point : Marker2D = $Marker2D

var muzzle_offset = Vector2(15, -22)  # Offset for right
var shoot_cooldown = 0.3
var shoot_timer = 0.0

func _ready():
	bullet_spawn_point.position = muzzle_offset  # Ensure it's correct on start

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement Input
	var direction := Input.get_axis("ui_left", "ui_right")


	# Sprite flip and muzzle adjustment
	if direction > 0:
		animated_sprite.flip_h = false
		bullet_spawn_point.position = muzzle_offset
	elif direction < 0:
		animated_sprite.flip_h = true
		bullet_spawn_point.position = Vector2(-muzzle_offset.x, muzzle_offset.y)

	# Handle Shooting
	shoot_timer -= delta
	if Input.is_action_just_pressed("shoot") and shoot_timer <= 0 and animated_sprite.animation != "jump":
		shoot_timer = shoot_cooldown
		shoot_bullet()
		animated_sprite.play("shoot")
	elif not is_shooting():
		# Normal animations
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("running")
		else:
			animated_sprite.play("jump")

	# Horizontal movement
	if direction:	
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

# Check if shooting is still active
func is_shooting() -> bool:
	return animated_sprite.animation == "shoot" and animated_sprite.is_playing()


func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()
	bullet_instance.position = global_position + bullet_spawn_point.position
	bullet_instance.direction = Vector2.RIGHT if not animated_sprite.flip_h else Vector2.LEFT
	get_tree().current_scene.add_child(bullet_instance)