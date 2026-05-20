extends Node

var discovered_evidence: Array[String] = []

func register_evidence(id: String):
	if not discovered_evidence.has(id):
		discovered_evidence.append(id)
		print("Evidence Registered: ", id)

func is_evidence_discovered(id: String) -> bool:
	return discovered_evidence.has(id)
