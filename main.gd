extends Node

@export var hud: HUD
@export var player: Player
@export var enemy_scene: PackedScene
@export var heart_scene: PackedScene
@export var coin_scene: PackedScene
@export var audioPlayer: AudioStreamPlayer2D

@onready var item_scenes = [heart_scene, coin_scene]

# TODO: Limits on scene's enemies and pickups spawned?
# Max enemies and items that can be spawned
var maxEnemies = 5
var maxPickups = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	""" Start a new game when the scene is created """
	# TODO: Dynamically add/remove upgrades (read from a file, unlock at Player milestones)	
	# Create the buy panels from a list
	var upgrades = [{"name": "Buy HP", "price": 10, "num": 0}, {"name": "two", "price": 15, "num": 0}]
	hud._create_buy_panels(upgrades)
	for buyPanel in get_tree().get_nodes_in_group("buyPanel"):
		_connect_button(buyPanel) # Would have to create a factory, with a keyword for each function choice that a button could call and be connected to
	# Further reading: https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
	
	_new_game()

func _new_game():
	""" Starts a new game """
	# Reset the timers
	$EnemyTimer.start()
	$ItemTimer.start()

	# Hide the game over window
	hud._toggle_game_over()
	
	# Reset the Player's stats abd update the HP display
	player._reset_player()
	_update_HP()
	
	audioPlayer.set_stream(load("res://music/squeak.wav"))	
	
	# TODO: Delete all enemies/pickups on screen
	

func _connect_button(buyPanel):
	""" Connect the buyPanel's button to the correct function """
	var buyButton = buyPanel.get_node("Button")
	var buyName = buyPanel.get_node("Label").text

	# Switch case based on buyName, assign to specific function
	if buyName == "Buy HP":
		buyButton.pressed.connect(_buy_HP)

	else:
		pass

func _end_game():
	""" Called when the user clicks 'exit' button """
	get_tree().quit() # Closes the program

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hud._update_coins(player._get_coins()) # TODO: Move to where coins changes/create signal
	if Input.is_action_pressed("click"):
		var mousePos = get_viewport().get_mouse_position()
		print("Mouse Click at ", get_viewport().get_mouse_position())
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if enemy._is_hit(mousePos):
				player._update_coins(enemy._get_value())
				enemy._delete()
	
func _spawn_item_on_path(scene, path):
	pass

func _spawn_enemy():
	""" Spawns an enemy on the enemy path """
	var enemy = enemy_scene.instantiate()
	
	# TODO: Create a decorator version of object spawning
	# Steps: create, set rotation, set velocity, set exist time, etc
	# Ex: A pickup does not need to be rotated/given velocity, but a projectile/bullet would be given all
	#var node = "" + "EnemySpawnPath" + "/Location"
	
	# Get the location from the path
	var spawn_location = get_node("EnemySpawnPath/Location")
	
	# Set the enemy's direction perpendicular to the path direction.
	var direction = spawn_location.rotation + PI / 2

	# Set the enemy's position to a random location.
	enemy.position = spawn_location.position
	
	# TODO: Target player instead of randomly moving

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	#enemy.rotation = direction

	# Choose the velocity for the enemy.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)

	# Spawn the item by adding it to the Main scene.
	add_child(enemy)
	audioPlayer.play()
	
func _spawn_pickup():
	""" Spawns a random Item on the item path """
	var item = item_scenes[(randi() % 2) - 1].instantiate()
	
	# Set the item's position to a random location
	item.position = get_node("ItemSpawnPath/Location").position

	# Spawn the item by adding it to the Main scene
	add_child(item)

func _game_over():
	""" Ends the game """
	# TODO: Disable player movement
	# TODO: Disable button clicks for upgrades
	
	# Disable timers for object spawning
	$EnemyTimer.stop()
	$ItemTimer.stop()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("items", "queue_free")

	# Displays the "Game Over" screen
	hud._toggle_game_over()

func _update_HP():
	""" Updates the health in the hud, checking if the player has died """
	var playerHealth = player._get_HP()
	
	# If the player has died,
	if playerHealth <= 0:
		_game_over()
	
	# Update the displayed HP bar
	hud._update_health(playerHealth, player._get_max_HP())

func _buy_HP():
	""" A purchasable upgrade called by a buy panel button """
	# TODO: Get buyPrice from upgrades
	# Create global? (object?) upgrades directory, assigning "upgrade": "Buy HP" a "price" value
	var buyPrice = 1
	if player._get_coins() >= buyPrice:
		player._update_coins(-1 * buyPrice)
		player._update_max_HP(1)
