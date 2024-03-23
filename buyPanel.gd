class_name BuyPanel extends Control

@export var buyName: Label
@export var button : Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_text(name, price):
	"""Fill in the BuyPanel with the given name and price"""
	buyName.text = name
	button.text = str(price)
	
func _activate_button():
	"""The button is active if the """
	button.disabled = !button.disabled
