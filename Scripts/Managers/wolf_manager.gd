extends Node

var wolves:Array[Wolf]
var wolvesAreAngry:bool = false
var angryTime:float = 15

func _ready() -> void:
	Manager.OnFightFinish.connect(ResetManager)
	
func ResetManager():
	wolves.clear()
	wolvesAreAngry = false

func RegisterWolf(newWolf:Wolf):
	if(wolves.has(newWolf)):return
	wolves.append(newWolf)
	
	if(wolvesAreAngry):
		newWolf.ReceiveHowl()
		
func RemoveWolf(wolfToRemove:Wolf):
	if(wolves.has(wolfToRemove)):
		wolves.erase(wolfToRemove)
	
func SpreadHowl():
	if(wolvesAreAngry):return
	wolvesAreAngry = true
	for wolf in wolves:
		if(!wolf.isAngry):
			wolf.ReceiveHowl()
	CalmWolves()


func CalmWolves():
	await get_tree().create_timer(angryTime).timeout
	for wolf in wolves:
		wolf.StopAngryState()
	wolvesAreAngry = false
