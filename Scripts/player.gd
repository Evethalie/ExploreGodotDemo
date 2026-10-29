extends CharacterBody2D

#export exposes var to inspector
#how fast the player runs, in pixels per second
@export var speed: float = 100.0

#how hard the player jumps. Negative numbers point up
@export var jump_velocity: float = -300.0

#if the player falls below this height the level restarts
@export var fall_limit: float = 400.0

# Where the player comes back after dying.
var respawn_position: Vector2

#onready tells the engine to wait until a node and its children 
#have finished entering the scene tree before assigning a value to a variable
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var camera: Camera2D = $Camera2D
#Godot calls _ready() once, when the player appears in the game.
func _ready() -> void:
	#add_to_group("player") 
	#gives the player a tag named player. 
	#Coins, spikes, and checkpoints check for this tag
	add_to_group("player")
	# The starting spot is the first respawn position.
	respawn_position = global_position

func _physics_process(delta: float) -> void:
	#Step 1: Fall when the player is not standing on anything 
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Step 2: Jump when the jump key is pressed
	#and the player is on the floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	# Cut the jump short when the jump key is released early.
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5
	
	#Step 3: Run left or right.
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = direction * speed
	else:
		#ease towards 0 if not moving
		velocity.x = move_toward(velocity.x,0.0, speed)
		
	#Step 4: Move, and stop at walls and floors
	move_and_slide()
	
	#Step 5: pick the right animation
	update_animation(direction)
	
	#Step 6: Restart if the player falls out of the level
	if global_position.y > fall_limit:
		die()
func update_animation(direction: float) -> void:
	#Face the direction the player is moving
	if direction > 0.0:
		animated_sprite.flip_h = false
	elif direction < 0.0:
		animated_sprite.flip_h = true
	
	#choose an animation
	if not is_on_floor():
		if velocity.y < 0.0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	elif direction != 0.0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart_level()

func die() -> void:
	global_position = respawn_position
	velocity = Vector2.ZERO
	camera.reset_smoothing()


func set_respawn_position(new_position: Vector2) -> void:
	respawn_position = new_position

#.call_deferred() waits until Godot finishes the 
#current physics step before reloading. Reloading in the middle of a physics step causes errors.
func restart_level() -> void:
	Game.reset_coins()
	get_tree().reload_current_scene.call_deferred()
