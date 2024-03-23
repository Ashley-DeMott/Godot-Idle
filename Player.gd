class_name Player extends Area2D # This class "Player" inherits all functionality of an Area2D
signal HPChange # The Player's HP changes

@export var speed = 400 # The speed of the Player
@export var startingHP = 15 # The starting maxHP

var screen_size # Size of game window
var startingPos
var health # The Player's starting health
var maxHP  # The Player's maximum health
var coins = 0 # The Player's points

func _ready():
	""" Called when the node enters the scene tree for the first time """
	# Calculate the starting position of the player
	screen_size = get_viewport_rect().size	
	startingPos = Vector2(screen_size.x / 2, screen_size.y / 2)

func _reset_player():
	""" Resets the Player's stats """
	position = startingPos
	coins = 0 # Resets the coin values
	_set_max_HP(startingHP)	 # Resets the maxHP
	health = maxHP
		
	# Enable collisions
	$CollisionShape2D.disabled = false

func _process(delta):
	""" Called every frame with 'delta' being the elapsed time since the previous frame """	
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
	
	# If an Item collides with the Player
	if(body.is_in_group("items")):
		if(body.is_in_group("coins")):
			coins += body._get_value()
		elif (body.is_in_group("healing")):
			_update_HP(body._get_value())
		body._delete() # The Item was collected, delete from game
			
	# TODO: Could specify enemy types (enemyB adds knockback, enemyC gives 'paralysis' effect)
	elif(body.is_in_group("enemies")):
		_update_HP(-1 * body._get_value())
		body._delete()

func _get_coins():
	""" Get the number of coins the Player has """
	return coins

func _update_coins(change):
	""" Update the number of coins the Player has """
	if change < coins:
		pass # TODO: Could throw assert to ensure no invalid purchases (purchases check first, then call update)
	coins += change
	
func _get_HP():
	""" Get the Player's health """
	return health

func _update_HP(change):
	""" Update the Player's health points """
	health += change
	if health < 0:
		health = 0 # Don't show negative values
	elif health > maxHP:
		health = maxHP # Don't go over max
	HPChange.emit()

func _set_max_HP(newMax):
	""" Set the Player's maximum HP """
	if newMax >= 0:
		maxHP = newMax

func _get_max_HP():
	""" Return the Player's maximum health """
	return maxHP

func _update_max_HP(change):
	""" Update the Player's maximum HP """
	maxHP += change
	HPChange.emit()
