class_name RedstoneLink

extends Area3D

@export var isActive:bool = false
@export var isPowerOn:bool = false
@export var isPowerSource:bool = false
@export var updateTick:float = 0.25
@export var radius:float = 0.15
@export var castLength:float = 0.3

@export var drawDebug:bool = false

@export var linkDirections:Array[Vector3] = [Vector3.UP,Vector3.DOWN,Vector3.RIGHT,Vector3.LEFT]

var parentRedstone:RedstoneLink = null
var childRedstones:Array[RedstoneLink]
var redstoneSource:RedstoneLink

signal TurnedOn
signal TurnedOff
signal PowerStateChanged(isOn:bool)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.gameManager.redstone_manager.RegisterRedstone(self)
	TurnedOn.connect(OnTurnedOn)
	TurnedOff.connect(OnTurnedOff)
	PowerStateChanged.connect(OnPowerStateChanged)
	#call_deferred("StartSource")
	call_deferred("RedstoneUpdate")
	
	
func StartSource():
	if(isActive and isPowerOn):
		GetRedstoneChildren()
		PropagateStateInChild()
	
func _process(delta: float) -> void:
	DebugRedstoneState()
	#GetConnectedRedstoneLinks()
	pass
	
func DebugRedstoneState():
	if(!drawDebug):return
	var color:Color = Color.CHOCOLATE
	if(isPowerOn):color = Color.FOREST_GREEN
	DebugDraw3D.draw_sphere(global_position,radius/3,color,updateTick)
	
	if(redstoneSource):
		var sourceColor := Color.BLUE_VIOLET
		DebugDraw3D.draw_arrow(redstoneSource.global_position,global_position,sourceColor,0.05)
	
	#draw tree
	#if(parentRedstone):
		#var parentColor:Color = Color.BLACK
		#DebugDraw3D.draw_arrow(global_position,parentRedstone.global_position,parentColor,0.05)
		##DebugDraw3D.draw_line(global_position,parentRedstone.global_position,color)
		#
	#var childColor:Color = Color.BLUE_VIOLET
	#for child in childRedstones:
		#if(!child):return
		#DebugDraw3D.draw_arrow(global_position,child.global_position,childColor,0.05)
		##DebugDraw3D.draw_line(global_position,child.global_position,childColor)
	
	
func RedstoneUpdate():
	await get_tree().create_timer(updateTick).timeout
	if(isActive and isPowerSource):
		PropagatePowerFromSource(self)
		
	if(!isPowerSource and !redstoneSource):
		ChangePowerState(false)
		
	RedstoneUpdate()
	
func ConnectParent(parent:RedstoneLink):
	parentRedstone = parent

#connect to all possible child
func GetRedstoneChildren():
	var links := GetConnectedRedstoneLinks()
	for link in links:
		ConnectChild(link)

#connect a new child
func ConnectChild(child:RedstoneLink):
	if(!child):return
	if(child == parentRedstone):return
	if(!child.isActive):return
	if(childRedstones.has(child)):return
	
	child.ConnectParent(self)
	childRedstones.append(child)
	child.tree_exiting.connect(RemoveChild)
	print("Connect redstone child : " + str(child))
	
func RemoveChild(child:RedstoneLink):
	if(!childRedstones.has(child)):return
	childRedstones.erase(child)
	
func ChangePowerState(isOn:bool):
	if(isOn == isPowerOn):return
	isPowerOn = isOn
	
	PowerStateChanged.emit(isPowerOn)
	
	if(isPowerOn):
		TurnedOn.emit()
	else:
		TurnedOff.emit()
		
func PropagateStateInChild():
	for child in childRedstones:
		if(!child):return
		child.ChangePowerState(isPowerOn)
		
func PropagatePowerFromSource(source:RedstoneLink):
	if(!source):return
	redstoneSource = source
	ChangePowerState(redstoneSource.isPowerOn)
	var links := GetConnectedRedstoneLinks()
	for link in links:
		if(link != redstoneSource and link.isActive):
			link.PropagatePowerFromSource(self)
		
func OnTurnedOn():
	#GetRedstoneChildren()
	#PropagateStateInChild()
	pass
	
func OnTurnedOff():
	pass
	
func OnPowerStateChanged(isOn:bool):
	#PropagateStateInChild()
	pass
	
#get redstones links in every link directions
func GetConnectedRedstoneLinks() -> Array[RedstoneLink]:
	var results:Array[RedstoneLink]
	
	for direction in linkDirections:
		var redstone := CheckRestoneLink(global_position,castLength,direction)
		if(redstone): results.append(redstone)
		
	return results
	
	
func CheckRestoneLink(castOrigin:Vector3,castLength:float,castDirection:Vector3) -> RedstoneLink:
	#create raycast
	var queryStart: Vector3 = castOrigin
	var queryEnd : Vector3 = castOrigin + (castDirection.normalized() * castLength)
	
	var space_state = get_world_3d().direct_space_state
	var queryMask = mask_from_layers([9])
	#print("MASK = " + str(queryMask))
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	query.collide_with_areas = true
	query.exclude.append(get_rid())
	var result = space_state.intersect_ray(query)
	
	#if(drawDebug):
		#DebugDraw3D.draw_line(queryStart,queryEnd,Color.RED,6)
	
	if result:
		print("REDSTONE RESULT FOUND...")
		#print("REDSTONE RESULT FOUND : "  + str(result))
		if(result.collider.is_in_group("Redstone")):
			print("REDSTONE RESULT FOUND IN GROUP")
			#if(drawDebug):
				#DebugDraw3D.draw_sphere(result.position,0.1,Color.SKY_BLUE,6)
			if(result.collider is RedstoneLink):
				print("REGISTER REDSTONE RESULT : "  + str(result))
				return result.collider as RedstoneLink
			else:
				return null
		else:
			return null
	else:
		print("NO RESULT")
		return null

func mask_from_layers(layers: Array[int]) -> int:
	var mask := 0
	for layer in layers:
		mask |= 1 << (layer - 1) # Active corresponding bit layer
	return mask
