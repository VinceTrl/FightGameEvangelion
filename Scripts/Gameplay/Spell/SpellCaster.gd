extends Node

@export var spells:Array[SpellData]

@export var spellStartNode:Node3D

@export_group("Target settings")
@export var yTargetStart:float = 4.0
@export var zTarget:float = 0.0
@export var xRange:Vector2 = Vector2(-4,4)
@export var yRange:Vector2 = Vector2(0.75,2.5)
@export_flags_3d_physics var targetMask = 1
@export var groundOffset:float = 0.025

@onready var spell_trail_vfx: Node3D = $SpellTrailVFX


const SPELL_CAST_VFX = preload("uid://dpg80ckyq67o3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitSpell()
	TEMP_SpellTimer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func InitSpell():
	for spell in spells:
		spell.loadedScene = load(spell.spellScene.resource_path)
	pass
	#for item in items: 	
		#item.resource = load(str(item.scenePath))
		
		
func TEMP_SpellTimer():
	await get_tree().create_timer(5.0).timeout
	RandomSpell()
	TEMP_SpellTimer()
	pass
		
func RandomSpell():
	CastSpell(spells.pick_random())
	pass
		
func CastSpell(data:SpellData):
	if(data.loadedScene):
		
		#Get spell target and location
		var targetNode:Node3D = null
		var targetLocation:Vector3 = Vector3.ZERO
		var target := data.targetType
		match target:
			SpellData.SpellTargetType.Random:
				targetLocation = GetRandomPosition() + (Vector3.UP * groundOffset)
				if(!data.spawnOnGround):
					targetLocation = targetLocation + (Vector3.UP * randf_range(yRange.x,yRange.y))
			SpellData.SpellTargetType.Player:
				targetNode = Manager.gameManager.GetRandomPlayer()
				targetLocation = targetNode.global_position
				
		#Vfx and delay
		spell_trail_vfx.StartTrail(spellStartNode.global_position,targetLocation)
		await spell_trail_vfx.TrailFinished
		
		SpawnSpellFx(targetLocation)
		await get_tree().create_timer(data.castDelay).timeout
		
		#Spawn Spell
		var scene = data.loadedScene.instantiate()
		if(scene is Spell):
			scene = scene as Spell
			add_child(scene)
			scene.global_position = targetLocation
			scene.CastSpell(data.lifeTime)
		else:
			push_error("INSTANTIATE WRONG CLASS IN SPELL CASTER")
			
		

#
func SpawnSpellFx(position:Vector3,rotation:Vector3 = Vector3.ZERO):
	var vfx = SPELL_CAST_VFX.instantiate()
	add_child(vfx)
	vfx.global_position = position
	vfx.global_rotation = rotation


func GetRandomPosition() ->Vector3:
	
	#create raycast
	var start := Vector3(randf_range(xRange.x,xRange.y),yTargetStart,zTarget)
	var queryStart: Vector3 = start
	var queryEnd : Vector3 = start + (Vector3.DOWN * 10)
	
	var space_state = get_viewport().get_camera_3d().get_world_3d().direct_space_state
	var queryMask = targetMask
	var query = PhysicsRayQueryParameters3D.create(queryStart,queryEnd,queryMask)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.hit_from_inside = true
	var result = space_state.intersect_ray(query)
	
	if result:
		return result.position
	else:
		return Vector3(randf_range(xRange.x,xRange.y),randf_range(xRange.x,xRange.y),zTarget)
