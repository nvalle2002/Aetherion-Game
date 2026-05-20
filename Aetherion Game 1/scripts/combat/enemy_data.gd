extends Resource
class_name EnemyData

@export var enemy_name: String = ""
@export var base_health: int = 50
@export var base_attack: int = 10
@export var corruption_class: QuestEntry.Classification = QuestEntry.Classification.STRUCTURAL_DEVIATION
@export var dialogue_fragments: Array[String] = []
