extends CharacterBody2D

@export var speed: float = 150.0
@export var acceleration: float = 1200.0
@export var friction: float = 1200.0

@onready var interaction_area: Area2D = $InteractionArea

var input_vector: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if DialogueManager.is_active:
		velocity = Vector2.ZERO
		return
		
	# Movement Logic
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	# Interaction Input
	if Input.is_action_just_pressed("interact"):
		check_interaction()
	
	# Reality Persistence (Save/Load)
	if Input.is_action_just_pressed("quick_save"):
		SaveManager.save_game()
	if Input.is_action_just_pressed("quick_load"):
		SaveManager.load_game()

func check_interaction() -> void:
	var areas = interaction_area.get_overlapping_areas()
	var closest_interactable = null
	var shortest_dist = INF
	
	for area in areas:
		if area is Interactable:
			var dist = global_position.distance_to(area.global_position)
			if dist < shortest_dist:
				shortest_dist = dist
				closest_interactable = area
	
	if closest_interactable:
		closest_interactable.interact(self)
