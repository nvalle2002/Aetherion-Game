extends CharacterBody2D

@export var npc_name: String = "Villager"
@export var dialogue_resource: DialogueResource

@onready var interactable = $Interactable

func _ready():
	interactable.interacted.connect(_on_interacted)

func _on_interacted(_player):
	if dialogue_resource:
		DialogueManager.start_dialogue(dialogue_resource)
