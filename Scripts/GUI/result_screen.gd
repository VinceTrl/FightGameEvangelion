class_name ResultScreen
extends Control

var win_text: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = self
	if(node is Control):
		node as Control
		var childrens = get_all_descendants(node)
		
		for child in childrens:
			if(child is Label):
				win_text = child
				print("text found")
		
	node.visible = false
	
func get_all_descendants(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		result.append(child)
		result += get_all_descendants(child)
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func StartResult():
	Manager.gameManager.GetWinner()
	
	var winnerText = "Player" + str(Manager.gameManager.GetWinner().playerID)
	win_text.text = winnerText + " Wins"
	self.visible = true
