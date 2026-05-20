extends Node

var active_enemy: EnemyData
var enemy_health: int

func start_battle(enemy: EnemyData):
	active_enemy = enemy
	enemy_health = enemy.base_health
	get_tree().change_scene_to_file("res://scenes/battle/battle_scene.tscn")

func observe():
	QuestLog.add_observation(
		"obs_" + active_enemy.enemy_name.to_snake_case(),
		"Observation: " + active_enemy.enemy_name,
		active_enemy.corruption_class,
		"Combat",
		"Instability detected: " + str(active_enemy.dialogue_fragments),
		QuestEntry.Confidence.MEDIUM
	)
	return "Observation logged to reconstruction engine."
