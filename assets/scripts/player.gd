extends CharacterBody2D
class_name Player;

@export var speed: float = 70;
@export var jump_speed: float = -200;
@export var dash_speed: float = 100;
@export var dash_lift: float = 50;
@export var acceleration: float = 0.12;
@export var deceleration: float = 0.3;

@onready var dash_cooldown = $DashCooldown;
@onready var dash_length = $DashLength;

var can_dash: bool = true;
var dashing: bool = false;
var climbing: bool = false;

var cur_decel: float = deceleration;

func platformer_movement(dt: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * dt;

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_speed;

	if (not dashing and Input.is_action_pressed("Right")):
		velocity.x = lerp(velocity.x, speed, acceleration);
	elif (not dashing and Input.is_action_pressed("Left")):
		velocity.x = lerp(velocity.x, -speed, acceleration);
	else:
		velocity.x = lerp(velocity.x, 0.0, cur_decel)
	
	if (Globals.unlocked_dash and can_dash and Input.is_action_just_pressed("Dash")):
		can_dash = false;
		dash_cooldown.start();
		
		dashing = true;
		dash_length.start();
		
		if Input.is_action_pressed("Right"):
			velocity.x+=dash_speed;
		elif Input.is_action_pressed("Left"):
			velocity.x-=dash_speed;
			
		if (velocity.y != 0):
			velocity.y -= dash_lift;
	
	if (dashing):
		cur_decel = 0;
		velocity.y = 0;
	else:
		cur_decel = deceleration;

func climb_movement() -> void:
	if Input.is_action_pressed("Right"):
		velocity.x = lerp(velocity.x, speed, acceleration);
	elif Input.is_action_pressed("Left"):
		velocity.x = lerp(velocity.x, -speed, acceleration);
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration)
	
	if Input.is_action_pressed("Down"):
		velocity.y = lerp(velocity.y, speed, acceleration);
	elif Input.is_action_pressed("Up"):
		velocity.y = lerp(velocity.y, -speed, acceleration);
	else:
		velocity.y = lerp(velocity.y, 0.0, deceleration);

func _physics_process(delta: float) -> void:
	if (climbing):
		climb_movement();
	else:
		platformer_movement(delta);
		
	move_and_slide();

func _on_dash_cooldown_timeout() -> void:
	can_dash = true;

func _on_dash_length_timeout() -> void:
	dashing = false;
