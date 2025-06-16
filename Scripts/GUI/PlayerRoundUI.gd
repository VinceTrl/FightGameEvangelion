extends Label

@export var playerID = 1
var Icons: Array[NodePath]

var roundWon = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateIcons()
	UpdateScore()
	#Manager.scoreManager.connect("onScoreUpdated",UpdateIcons)
	Manager.scoreManager.onScoreUpdated.connect(UpdateScore)
	
func UpdateScore():
	if(playerID == 1):
		roundWon = Manager.scoreManager.playerWinCount_1
	else:
		roundWon = Manager.scoreManager.playerWinCount_2
		
	text = str(roundWon)

func UpdateIcons():
	
	for icon in Icons:
		var node = get_node_or_null(icon)
		if node and node.get_child_count() > 0:
			var first_child = node.get_child(0)
			first_child.visible = false
	
	var _round
	if(playerID == 1):
		_round = Manager.scoreManager.playerWinCount_1
	else:
		_round = Manager.scoreManager.playerWinCount_2
		
	roundWon = _round
	
	print("UPDATE ICONS ID"  + str(playerID) + " : " + str(roundWon))
	
	var count = 0
	for icon in Icons:
		
		if(count >= roundWon): return
		count += 1
		
		var node = get_node_or_null(icon)
		#print("get node : " + str(node))
		if node and node.get_child_count() > 0:
			var first_child = node.get_child(0)
			#first_child as CanvasItem
			first_child.visible = true
			#print("set visible : " + str(first_child))
