extends Node
signal freeze # Emitted when the player's movements should be frozen

# If the game is over
var gameOver = false

# @export allows nodes to be specified inside the editor
@export var hud: HUD # The UI that displays health, coins, and upgrades menu
@export var enemySound: AudioStreamPlayer2D # For playing sound effects, specifically enemy spawns

# The Player that can be controlled through wasd and arrow keys
@export var player: Player

# The Enemies to be spawned
# TODO: Make into a list of enemies to spawn
@export var enemy_scene: PackedScene

# The pickup Items to be spawned
# TODO: export as an array of PackedScenes to be selected
@export var heart_scene: PackedScene
@export var coin_scene: PackedScene
@onready var item_scenes = [heart_scene, coin_scene]

# Spawn timers and their original times
@onready var enemyTimer = $EnemyTimer
@onready var enemyTimerStart = enemyTimer.wait_time
@onready var itemTimer = $ItemTimer
@onready var itemTimerStart = enemyTimer.wait_time

# The upgrades available for purchase
# TODO: allUpgrades, with every upgrade that can be unlocked
# TODO: Dynamically add/remove upgrades (read from a file, unlock at Player milestones)	
var upgrades

# TODO: Limits on scene's enemies and pickups spawned? (also checking garbage collection)
# Max enemies and items that can be spawned
#var maxEnemies = 5
#var maxPickups = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	""" Start a new game and load upgrades when the scene is created """	
	_load_upgrades()
	_new_game()
	
func _load_upgrades():
	""" Loads purchasable upgrades, creating buy panels and connecting the buy buttons """
	# Create buy panels from a list of upgrades
	upgrades = [	{"name": "Buy HP", "price": 5, "num": 0}, 
					{"name": "Enemy Spawn", "price": 15, "num": 0},
					{"name": "Item Spawn", "price": 10, "num": 0} ]
	hud._create_buy_panels(upgrades)
	
	# Connect each buyPanel's button to a specific function
	for buyPanel in get_tree().get_nodes_in_group("buyPanel"):
		# Using a factory, with a keyword for each function that a button can be connected to
		# Further reading: https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
		_connect_button(buyPanel)

func _connect_button(buyPanel):
	""" Connect the buyPanel's button to the correct function """
	var buyButton = buyPanel.get_node("Button")
	var buyName = buyPanel.get_node("Label").text

	# Switch case based on buyName, assign to specific function
	# TODO: Add more upgrade options
	if buyName == "Buy HP":
		buyButton.pressed.connect(_buy_HP)
	elif buyName == "Enemy Spawn":
		buyButton.pressed.connect(_buy_enemy_spawn)
	elif buyName == "Item Spawn":		
		buyButton.pressed.connect(_buy_item_spawn)
	# Ideas: swords around player, 
	else:
		# Could throw assert, invalid upgrade loaded
		buyPanel.queue_free() # Deletes the panel, can't purchase

func _new_game():
	""" Starts a new game """
	# Reset the timers to their original times
	enemyTimer.wait_time = enemyTimerStart
	enemyTimer.start()
	itemTimer.wait_time = itemTimerStart
	itemTimer.start()

	# Hide the game over window
	hud._show_game_over(false)
	
	# Reset the Player's stats abd update the HP display
	player._reset_player()
	_update_HP()
	
	# Set the "Enemy Spawn" sound
	enemySound.set_stream(load("res://music/squeak.wav"))	
	
	_remove_items()
	gameOver = false
	
func _end_game():
	""" Called when the user clicks 'exit' button """
	get_tree().quit() # Closes the program

func _process(delta):
	""" Called every frame with 'delta' being the elapsed time since the previous frame """
	# If the game is not over,
	if !gameOver:
		hud._update_coins(player._get_coins()) # TODO: Move to where coins changes/create signal
		
		# Defeat enemies with a clicj=k
		if Input.is_action_pressed("click"):
			var mousePos = get_viewport().get_mouse_position()
			
			# Check if an enemy has been hit
			for enemy in get_tree().get_nodes_in_group("enemies"):
				if enemy._is_hit(mousePos):
					player._update_coins(enemy._get_value()) # TODO: Change to exp
					enemy._delete() # Delete the hit enemy
	
func _spawn_item_on_path(scene, path):
	# TODO: Create a decorator version of object spawning
	# Steps: create, set rotation, set velocity, set exist time, etc
	# Ex: A pickup does not need to be rotated/given velocity, but a projectile/bullet would be given all
	#var node = "" + "EnemySpawnPath" + "/Location"
	pass

func _spawn_enemy():
	""" Spawns an enemy on the enemy path """
	var enemy = enemy_scene.instantiate()	
	
	# Get the location from the path
	var spawn_location = get_node("EnemySpawnPath/Location")
	
	# Set the enemy's direction perpendicular to the path direction.
	var direction = spawn_location.rotation + PI / 2

	# Set the enemy's position to a random location.
	enemy.position = spawn_location.position
	
	# TODO: Target player instead of randomly moving (Enemy's update)
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)

	# Choose the velocity for the enemy
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)

	# Add the Enemy to the main scene, playing a sound
	add_child(enemy)
	enemySound.play() # 
	
func _spawn_pickup():
	""" Spawns a random Item on the item path """
	var item = item_scenes[(randi() % 2) - 1].instantiate()
	
	# Set the item's position to a random location
	item.position = get_node("ItemSpawnPath/Location").position

	# Spawn the item by adding it to the Main scene
	add_child(item)

func _game_over():
	""" Ends the game """
	gameOver = true
	freeze.emit() # Tell other scripts that the game is over
	
	# TODO: Disable button clicks for upgrades panel
	
	# Disable timers for object spawning
	$EnemyTimer.stop()
	$ItemTimer.stop()

	# Displays the "Game Over" screen
	hud._show_game_over(true)

func _remove_items():
	""" Removes all Enemies and items from the field"""	
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("items", "queue_free")

func _update_HP():
	""" Updates the health in the hud, checking if the player has died """
	var playerHealth = player._get_HP()
	
	# If the player has died,
	if playerHealth <= 0:
		_game_over()
	
	# Update the displayed HP bar
	hud._update_health(playerHealth, player._get_max_HP())

func _get_upgrade(upgradeName):
	""" Get the specified upgrade from the upgrades list """
	var upgrade = null
	
	# Attempt to find the upgrade within upgrades list
	for u in upgrades:
		if u["name"] == upgradeName:
			upgrade = u
	
	if upgrade != null:
		return upgrade
	else:
		# TODO: Specify error for debuging
		assert(false)

# TODO: Use for UI enabling of purchase buttons
func _can_purchase(upgrade):
	""" Returns if the given upgrade can currenlty be purchased """
	return player._get_coins() >= upgrade["price"]

func _purchase_upgrade(upgradeName):
	""" Atempts to purchase the next level of an upgrade, returning if it was successful """
	# Find the upgrade's information from the list of upgrades
	var upgrade = _get_upgrade(upgradeName)

	# Determine if the upgrade can be purchased
	# TODO: Max level? upgrade["level"] < upgrade["maxLevel"]
	if _can_purchase(upgrade):
		player._update_coins(-1 * upgrade["price"])
		# TODO: update upgrade's level/price for next purchase
		return true
	else: 
		return false

func _buy_HP():
	""" An upgrade that gives the Player more HP """
	if _purchase_upgrade("Buy HP"):
		# Update the player's HP
		player._update_max_HP(1) # TODO: Get value from upgrade, changing price and next HP upgrade value
		_update_HP()

func _buy_enemy_spawn():
	""" An upgrade that decreases the time for enemies to spawn """
	if _purchase_upgrade("Enemy Spawn"):
		enemyTimer.wait_time *= .5

func _buy_item_spawn():
	""" An upgrade that decreases the time for items to spawn """
	if _purchase_upgrade("Item Spawn"):
		itemTimer.wait_time *= .5
