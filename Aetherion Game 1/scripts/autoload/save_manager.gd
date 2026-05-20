extends Node

const SAVE_PATH = "E:/Aetherion Game 1/saves/save_001.json"

signal save_started
signal save_completed
signal load_started
signal load_completed

func save_game():
	print("STABILIZING REALITY FRAGMENTS...")
	save_started.emit()
	
	var save_data = {
		"WORLD_STATE": {
			"current_region": get_tree().current_scene.scene_file_path,
			"shrine_triggered": find_shrine_state(),
			"world_corruption_level": calculate_corruption()
		},
		"PLAYER_STATE": {
			"position": {
				"x": get_player().global_position.x if get_player() else 0,
				"y": get_player().global_position.y if get_player() else 0
			},
			"current_scene": get_tree().current_scene.scene_file_path,
			"anomaly_exposure_level": 0
		},
		"QUEST_LOG_STATE": QuestLog.get_state(),
		"EVIDENCE_STATE": {
			"discovered_evidence": EvidenceSystem.discovered_evidence
		},
		"SYSTEM_STATE": {
			"global_corruption_flags": QuestLog.is_unstable
		}
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		save_completed.emit()
	else:
		print("ERROR: FAILED TO STABILIZE REALITY")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	load_started.emit()
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var save_data = JSON.parse_string(json_string)
	if not save_data: return
	
	# Reconstruct World
	var target_scene = save_data["WORLD_STATE"]["current_region"]
	if get_tree().current_scene.scene_file_path != target_scene:
		get_tree().change_scene_to_file(target_scene)
		await get_tree().node_added
	
	# Reconstruct Player
	var player = get_player()
	if player:
		player.global_position = Vector2(
			save_data["PLAYER_STATE"]["position"]["x"],
			save_data["PLAYER_STATE"]["position"]["y"]
		)
	
	# Reconstruct Systems
	QuestLog.load_state(save_data["QUEST_LOG_STATE"])
	EvidenceSystem.discovered_evidence = save_data.get("EVIDENCE_STATE", {}).get("discovered_evidence", [])
	
	load_completed.emit()

func get_player():
	return get_tree().get_first_node_in_group("player")

func find_shrine_state() -> bool:
	var shrine = get_tree().get_first_node_in_group("shrine")
	if shrine: return shrine.has_triggered
	return false

func calculate_corruption() -> int:
	return 100 if QuestLog.is_unstable else 0
