extends CharacterBody2D
class_name Player;

@export var speed: float = 70;
@export var jump_speed: float = -200;
@export var dash_speed: float = 110;
@export var dash_lift: float = 50;
@export var acceleration: float = 0.12;
@export var deceleration: float = 0.3;

@onready var sprite = $AnimatedSprite2D
@onready var coyote_time = $CoyoteTime;
@onready var dash_cooldown = $DashCooldown;
@onready var dash_length = $DashLength;

var flip_h: bool = false;

var coyote_time_active: bool = false;
var can_dash: bool = true;
var dashing: bool = false;
var climbing: bool = false;

var jumps: int = 0;
var cur_decel: float = deceleration;

func _ready() -> void:
	add_to_group("player");

func platformer_movement(dt: float) -> void:
	if not is_on_floor():
		if (jumps == 0):
			jumps = Global.max_jumps;
		
		if (coyote_time.is_stopped() and coyote_time_active):
			coyote_time.start();
		
		velocity += get_gravity() * dt;
	else:
		coyote_time_active = true;
		coyote_time.stop();
		jumps = 0;
	
	# can jump if 1. grounded 2. coyote time active or 3. coyote time is no longer acitve but you have more jumps to use
	if (Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_time_active or (not coyote_time_active and jumps < Globals.max_jumps))):
		velocity.y = jump_speed;
		coyote_time_active = false;
		coyote_time.stop();
		jumps+=1;

	if (not dashing and Input.is_action_pressed("Right")):
		velocity.x = lerp(velocity.x, speed, acceleration);
		flip_h = false;
	elif (not dashing and Input.is_action_pressed("Left")):
		velocity.x = lerp(velocity.x, -speed, acceleration);
		flip_h = true;
	else:
		velocity.x = lerp(velocity.x, 0.0, cur_decel)
		
	if (velocity.x != 0 and is_on_floor()):
		sprite.play("walk");
	
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
	# allows player to jump off ladder
	coyote_time_active = true;
	
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
	sprite.flip_h = flip_h;
	
	if (climbing):
		climb_movement();
	else:
		platformer_movement(delta);
		
	move_and_slide();

func _on_coyote_time_timeout() -> void:
	coyote_time_active = false;

func _on_dash_cooldown_timeout() -> void:
	can_dash = true;

func _on_dash_length_timeout() -> void:
	dashing = false;

func debug_show_coyote_time():
	if (coyote_time_active):
		self.modulate = Color.AQUAMARINE;
	else:
		self.modulate = Color.WHITE;
