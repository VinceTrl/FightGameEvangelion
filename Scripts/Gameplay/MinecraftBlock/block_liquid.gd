class_name BlockLiquid

extends Block

@export_category("Liquid Settings")
@export var isSide:bool
var isFacingRight:bool = true
var canUpdateShape:bool = true

const LAVA_BLOCK = preload("uid://bja86rnp5peep")

@export_group("Spread settings")
@export var canSpread:bool = true
@export var sideSpread:BlockSpread
@export var bottomSpread:BlockSpread

@export var leftRaycast:RayCast3D
@export var rightRaycast:RayCast3D
@export var downRaycast:RayCast3D
@export var upRaycast:RayCast3D
@export var leftGroundRaycast:RayCast3D
@export var rightGroundRaycast:RayCast3D



signal ChangedFacing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Manager.gameManager.block_manager.BlockTicked.connect(BlockTick)
	sideSpread.blockScene = LAVA_BLOCK
	bottomSpread.blockScene = LAVA_BLOCK
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func IsFacingRight():
	if(originBlock and isSide):
		#check if origin block is left
		if(originBlock.global_position.x > global_position.x): 
			isFacingRight = false
	
func TransformSideBlock():
	if(!canUpdateShape):return
	if(!isSide):return

	if(rightRaycast.is_colliding() and leftRaycast.is_colliding()):
		ConvertSideToFull()
	else:
		if(isFacingRight): 
			if(!rightRaycast.is_colliding() and rightGroundRaycast.is_colliding()):
				ConvertSideToFull()
			elif(!rightRaycast.is_colliding() and !rightGroundRaycast.is_colliding()):
				#sideSpread.SpreadUpdate()
				var spawnPosition := rightGroundRaycast.target_position + rightRaycast.target_position
				sideSpread.SpawnBlock(global_position + spawnPosition)
				canUpdateShape = false
				pass
		elif(!isFacingRight):
			if(!leftRaycast.is_colliding() and leftGroundRaycast.is_colliding()):
				ConvertSideToFull()
			elif(!leftRaycast.is_colliding() and !leftGroundRaycast.is_colliding()):
				#sideSpread.SpreadUpdate()
				var spawnPosition := leftGroundRaycast.target_position + leftRaycast.target_position
				sideSpread.SpawnBlock(global_position + spawnPosition)
				canUpdateShape = false
				pass
				
func ConvertSideToFull():
	canSpread = false
	var block := LAVA_BLOCK.instantiate()
	get_tree().current_scene.add_child(block)
	block.global_position = global_position
	queue_free()

func BlockTick():
	IsFacingRight()
	TransformSideBlock()
	SpreadBlocks()
	
	
func SpreadBlocks():
	if(!canSpread):return
	
	bottomSpread.SpreadUpdate()
	
	if(!isSide and downRaycast.is_colliding()):
		if(downRaycast.get_collider().owner is BlockLiquid):
			return
		sideSpread.SpreadUpdate()
	
