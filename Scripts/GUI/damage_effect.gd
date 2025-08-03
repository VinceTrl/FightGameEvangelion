extends TextureRect

@export var playerIndex:int = 0
@export var duration:float = 0.5
@export var alphaCurve:Curve
var timer:Timer
var player
var isPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#modulate.a = 0.0
	self_modulate.a = 0.0
	timer = CreateTimer()
	player = Manager.gameManager.players[playerIndex]
	
	if player== null:
		push_error("player not found in player BAR GUI: " + str(self.name))
		return
		
	
		
	player.OnPlayerTakeDamage.connect(StartDamageEffect)
	player.OnPlayerDeath.connect(StartDamageEffect)
	
	
func CreateTimer() -> Timer:
	var t = Timer.new()
	t.one_shot = true
	t.autostart = false
	t.wait_time = duration
	add_child(t)
	return t

func StartDamageEffect(_duration:float = duration):
	print("START DAMAGE EFFECT")
	if(isPlaying):
		timer.stop()
		
	timer.start(_duration)
	isPlaying = true
	
	while timer.time_left > 0.0:
		var _timeProgress = _duration - timer.time_left 
		var _ratio = _timeProgress/_duration
		var _curveValue = alphaCurve.sample(_ratio)
		var _alpha = lerp(0.0,1.0,_curveValue)
		self_modulate.a = _alpha
		
		print("DMG EFFECT ALPHA = " + str(_alpha))
		
		if !is_instance_valid(get_tree()):
			return
		
		await get_tree().process_frame
		
	self_modulate.a = 0.0
	isPlaying = false
	print("STOP Playing EFFECT")
