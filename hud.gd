class_name HUD extends CanvasLayer

# Signals that tell main to start/end the game
signal endGame
signal startGame

# Get specific nodes in the HUD
@export var upgradesList: VBoxContainer
@export var buyUpgrade: PackedScene
@export var numCoins : Label
@export var HPBar : ColorRect
@export var HP : ColorRect
@export var numHP : Label
	
func _create_buy_panels(upgrades):
	"""Creates a buy panel for each upgrade available"""
	for upgrade in upgrades:
		var upgradePanel = buyUpgrade.instantiate()
		upgradePanel._set_text(upgrade["name"], upgrade["price"])
		upgradesList.add_child(upgradePanel)

func _on_show_menu_pressed():
	""" Show the upgrades menu """
	$"Upgrades Menu".visible = true
func _on_close_button_pressed():
	""" Hide the upgrades menu """
	$"Upgrades Menu".visible = false

func _update_coins(coins):
	""" Update the displayed coins """
	numCoins.text = str(coins)
	
func _update_health(currentHP, maxHP):
	""" Update the HP bar """
	numHP.text = str(currentHP) + " / " + str(maxHP)
	
	# Scale the health bar to the ratio of currentHP/maxHP
	if currentHP == maxHP:
		HP.set_size(HPBar.get_size())
	else:
		var scale = float(currentHP) / float(maxHP)
		HP.set_size(Vector2(HPBar.get_size().x * scale, HPBar.get_size().y))

func _show_game_over(b):
	""" Set the visibility of the 'Game Over' window """
	$GameOver.visible = b

func _on_continue_pressed():
	""" The Player chose to continue the game, tell main script """
	startGame.emit() # Emit a 'startGame' signal that main recieves

func _on_quit_pressed():
	""" The Player chose to exit the game, tell main script """
	endGame.emit() # Emit an 'endGame' signal that main recieves
