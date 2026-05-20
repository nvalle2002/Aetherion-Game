extends Control

signal page_completed
signal dialogue_finished

@onready var text_label = %TextLabel
@onready var name_label = %NameLabel
@onready var portrait = %Portrait
@onready var continue_indicator = %ContinueIndicator
@onready var animation_player = $AnimationPlayer

@export var type_speed: float = 0.03

var _current_text: String = ""
var _is_typing: bool = false
var _page_index: int = 0
var _current_data: DialogueResource

func _ready():
	visible = false
	DialogueManager.update_ui_ref(self)

func display_page(speaker: String, text: String, portrait_tex: Texture2D = null):
	visible = true
	_current_text = text
	name_label.text = speaker
	text_label.text = ""
	portrait.texture = portrait_tex
	continue_indicator.visible = false
	
	_is_typing = true
	var current_visible = 0
	for char in text:
		text_label.text += char
		current_visible += 1
		# Simple typewriter delay
		await get_tree().create_timer(type_speed).timeout
		if not _is_typing: # Skip to end
			text_label.text = text
			break
	
	_is_typing = false
	continue_indicator.visible = true

func _input(event):
	if event.is_action_pressed("interact") and visible:
		if _is_typing:
			_is_typing = false # Fast forward
		else:
			DialogueManager.next_page()

func close():
	visible = false
	dialogue_finished.emit()
