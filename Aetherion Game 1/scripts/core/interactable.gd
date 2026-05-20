extends Area2D
class_name Interactable

signal interacted(body: CharacterBody2D)

@export var interact_label: String = "Interact"

func interact(player: CharacterBody2D) -> void:
	interacted.emit(player)
	print("Interacted with: ", name)
