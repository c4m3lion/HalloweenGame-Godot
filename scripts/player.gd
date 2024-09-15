extends CharacterBody2D


@export var SPEED = 130.0
@export var JUMP_VELOCITY = -300.0
@export var ROLL_SPEED = 200.0 # Faster movement while rolling
@export var ROLL_DURATION = 0.5 # Roll lasts for half a second

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_rolling: bool = false
var roll_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle rolling
	if Input.is_action_just_pressed("roll") and is_on_floor() and not is_rolling:
		start_roll()

	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0.0:
			stop_roll()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# 1,0,-1
	var direction := Input.get_axis("move_left", "move_right")
	
	if(direction > 0):
		animated_sprite.flip_h = false;
	elif(direction < 0):
		animated_sprite.flip_h = true;
	
	# animation
	if(is_on_floor() || is_rolling):
		if is_rolling:
			animated_sprite.play("roll")
		elif(direction == 0):
			animated_sprite.play("idle");
		else:
			animated_sprite.play("run");
	else:
		animated_sprite.play("jump");
	
	if is_rolling:
		velocity.x = ROLL_SPEED if not animated_sprite.flip_h else -ROLL_SPEED
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func start_roll() -> void:
	is_rolling = true
	roll_timer = ROLL_DURATION

func stop_roll() -> void:
	is_rolling = false
