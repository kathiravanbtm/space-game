extends CharacterBody2D

@export var speed: float = 20.0
@export var patrol_distance: float = 50.0

var direction := -1
var start_position: Vector2
const SPRITE_OFFSET_X = 14.5	 # Adjust as needed

func _ready():
    start_position = global_position

func _physics_process(_delta):
    velocity.x = direction * speed
    move_and_slide()
    if abs(global_position.x - start_position.x) >= patrol_distance:
        direction *= -1
        $AnimatedSprite2D.flip_h = direction < 0
        $AnimatedSprite2D.position.x = -SPRITE_OFFSET_X if direction < 0 else SPRITE_OFFSET_X

func take_damage(_amount: int) -> void:
    queue_free() # Kills the robot instantly