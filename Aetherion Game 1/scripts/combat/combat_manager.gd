extends Node

signal turn_started(entity)
signal battle_finished(victory)

var current_enemy: EnemyData
var enemy_health: int

func start_battle(enemy: EnemyData):
	current_enemy = enemy
	enemy_health = enemy.base_health
	print("BATTLE STARTED: ", enemy.enemy_name)

func observe_enemy():
	# Reveal instability info to QuestLog
	QuestLog.add_observation(
		"obs_" + current_enemy.enemy_name.to_snake_case(),
		"Observation: " + current_enemy.enemy_name,
		current_enemy.corruption_class,
		"Combat Encounter",
		"Enemy displays signs of " + QuestEntry.Classification.keys()[current_enemy.corruption_class] + ". Fragments: " + str(current_enemy.dialogue_fragments),
		QuestEntry.Confidence.MEDIUM
	)
	return "Enemy corruption pattern identified."

func player_attack():
	enemy_health -= 10
	print("Enemy Health: ", enemy_health)
	if enemy_health <= 0:
		battle_finished.emit(true)
