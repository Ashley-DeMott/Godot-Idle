class_name BuyPanel extends Control

# Specific nodes that make up the Panel
@export var buyName: Label
@export var button : Button

func _set_text(name, price):
	""" Fill in the BuyPanel with the given name and price """
	buyName.text = name
	button.text = str(price)
	
func _disable_button(b):
	""" Disable the button if the Player cannot purchase """
	button.disabled = b
