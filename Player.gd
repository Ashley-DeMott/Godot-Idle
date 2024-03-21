class_name Player extends Area2D # This class "Player" inherits all functionality of an Area2D
signal hit # TODO: Look back at tutorial for functionality, might be obsolete with current collision system

@export var speed = 400 # The speed of the Player
@export var health = 10 # The Player's health
var screen_size # Size of game window
var points = 0 # The Player's points

func _ready():
	""" Called when the node enters the scene tree for the first time """
	screen_size = get_viewport_rect().size
	
	# Starting position of the player
	position = Vector2(screen_size.x / 2, screen_size.y / 2)
	$CollisionShape2D.disabled = false

func _process(delta):
	""" Called every frame with 'delta' being the elapsed time since the previous frame """
	
	# TODO: Add game over element
	if health <= 0:
		health = 0
	
	# The player's movement vector.
	var velocity = _get_player_input(Vector2.ZERO)

	if velocity.length() > 0:
		# Normalize velocity to make sure it is 1, not faster diagonal
		velocity = velocity.normalized() * speed

	position += velocity * delta
	
	# Restrict movement to the screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
func _get_player_input(velocity):
	""" Translates user input into changes in velocity """
	# Get input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	return velocity

func _on_body_entered(body):
	""" Called when the Player's collision box is entered by a body """
	if(body.is_in_group("items")):
		points += body._get_points()
		body._player_hit()
		
	elif(body.is_in_group("enemies")):
		points -= 1
		#health -= body._get_points()
		body._player_hit()
		
func _get_points():
	""" Get the Player's points """
	return points
