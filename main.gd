extends Node

@export var hud: HUD
@export var player: Player
@export var enemy_scene: PackedScene
@export var item_scene: PackedScene

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
	hud._update_score(player._get_coins()) # TODO: Move to where coins changes/create signal
	
# TODO: Path doesn't seem to move, check path spawning
func _spawn_item_on_path(scene, path):
	var item = scene.instantiate()
	
	var node = "" + path + "/Location"
	
	# Get the location from the path
	var spawn_location = get_node(node)
	
	# Set the item's direction perpendicular to the path direction.
	var direction = spawn_location.rotation + PI / 2

	# Set the item's position to a random location.
	item.position = spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	item.rotation = direction

	# Choose the velocity for the item.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	item.linear_velocity = velocity.rotated(direction)

	# Spawn the item by adding it to the Main scene.
	add_child(item)

func _spawn_enemy():
	""" Spawns an enemy on the enemy path """
	#var enemy_spawn = $EnemySpawnPath/Location
	_spawn_item_on_path(enemy_scene, "EnemySpawnPath")	
	
func _spawn_pickup():
	""" Spawns a pickup item on the item path """
	#var item = item_scene.instantiate()	
	#var item_spawn = $ItemSpawnPath/ItemSpawnLocation
	_spawn_item_on_path(item_scene, "ItemSpawnPath")

func _game_over():
	""" Ends the game """
	# TODO: Disable player movement
	# TODO: Disable button clicks for upgrades
	
	# Disable timers for object spawning
	$EnemyTimer.stop()
	$ItemTimer.stop()
	
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
