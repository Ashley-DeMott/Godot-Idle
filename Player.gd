class_name Player extends Area2D # This class "Player" inherits all functionality of an Area2D
signal HPChange # Signal emitteed when the Player's HP changes (calls a function in Main)

@export var speed = 400 # The speed of the Player
@export var startingHP = 15 # The starting maxHP

var screen_size # Size of game window
var startingPos # The Player's starting position
var maxHP  # The Player's maximum health
var health # The Player's current health
var coins = 0 # The Player's points

# If the Player can move
var freeze = false

func _ready():
	""" Called when the node enters the scene tree for the first time """
	# Calculate the starting position of the player
	screen_size = get_viewport_rect().size	
	startingPos = Vector2(screen_size.x / 2, screen_size.y / 2)
	_reset_player()

func _reset_player():
	""" Resets the Player's stats """
	position = startingPos # Reset the Player's position
	coins = 0 # Resets the coin values DEBUG: 100 coins
	_set_max_HP(startingHP)	 # Resets the maxHP
	health = maxHP
		
	# Enable collisions and unfreeze the Player
	$CollisionShape2D.disabled = false
	freeze = false

func _process(delta):
	""" Called every frame with 'delta' being the elapsed time since the previous frame """	
	# If the game is not frozen,
	if !freeze:
		_move_player(delta)
	else:
		# Disable collisions
		$CollisionShape2D.disabled = true

func _move_player(delta):
	""" Adjsuts the player's position according user input """
	# The player's movement vector.
	var velocity = Vector2.ZERO
	
	# Translates user input into changes in velocity
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		# Normalize velocity to make sure it is 1, not faster diagonal
		velocity = velocity.normalized() * speed

	position += velocity * delta
	
	# Restrict movement to the screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Change the direction the Player's sprite is facing
	$Sprite2D.flip_h = velocity.x < 0

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

func _on_main_freeze():
	freeze = true
