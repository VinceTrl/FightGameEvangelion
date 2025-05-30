extends Node3D

var spawners: Array

@export var delayBetweenSpawnsMin = 0.01
@export var delayBetweenSpawnsMax = 0.05
@export var delayBetweenWavesMin = 1.0
@export var delayBetweenWavesMax = 2.0
@export var selectedSpawnerMin = 3
var selectedSpawnerMax
var canSpawn = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get all spawners
	for child in get_children():
		if(child is Spawner):
			spawners.append(child)
			
	selectedSpawnerMax = spawners.size()
	Manager.gameManager.game_timer.timeout.connect(LaunchWaves)
	Manager.gameManager.FightEnd.connect(DisableSpawn)
	
	
func LaunchWaves():
	SpawnWave()
	
func SpawnWave():
	if(!canSpawn): return
	
	var spawnerAmount = randi_range(selectedSpawnerMin,selectedSpawnerMax)
	var ranSpawners = pick_unique_random_elements(spawners,spawnerAmount)
	var spawnDelay = randf_range(delayBetweenSpawnsMin,delayBetweenSpawnsMax)
	var waveDelay = randf_range(delayBetweenWavesMin,delayBetweenWavesMax)
	
	print("spawners : " + str(ranSpawners))
	
	for spawn in ranSpawners:
		await get_tree().create_timer(spawnDelay).timeout
		if(spawn is Spawner):
			spawn as Spawner
			spawn.SpawnItem("FALLING PROJECTILE")
		
	await get_tree().create_timer(waveDelay).timeout
	SpawnWave()
	
	
func DisableSpawn():
	canSpawn = false
	
	
func pick_unique_random_elements(source_array: Array, count: int) -> Array:
	var copy = source_array.duplicate()
	copy.shuffle()
	return copy.slice(0, min(count, copy.size()))
