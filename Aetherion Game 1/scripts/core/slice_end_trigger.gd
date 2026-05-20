extends Area2D

@export var end_dialogue: DialogueResource

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and QuestLog.is_unstable:
		if end_dialogue:
			DialogueManager.start_dialogue(end_dialogue)
			DialogueManager.dialogue_finished.connect(_on_end_dialogue_finished, CONNECT_ONE_SHOT)
		else:
			_on_end_dialogue_finished()

func _on_end_dialogue_finished():
	print("VERTICAL SLICE COMPLETE: REALITY STABILIZED (FINAL SNAPSHOT)")
	SaveManager.save_game()
	# In a real build, we might transition to a credits screen here.
