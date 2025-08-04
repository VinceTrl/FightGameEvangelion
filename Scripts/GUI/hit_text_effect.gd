extends Control

@export var playerIndex:int = 0
@export var label:Label
@export var text:String = "Hit!"
@export var color:Color = Color.CHARTREUSE
@export var timeByChar:float = 0.25
@export var duration:float = 2
@export var alphaCurve:Curve
@export var useAlphaFlicker = false
@export var flickerDisplayDuration: float = 0.02

var timer:Timer
var player:PlayerCharacter
var isPlaying

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = color
	modulate.a = 0.0
	label.text = ""
	timer = CreateTimer()
	player = Manager.gameManager.players[playerIndex]
	
	if player== null:
		push_error("player not found in player BAR GUI: " + str(self.name))
		return
		
	player.OnPlayerTakeDamage.connect(HitReset)
	player.OnPlayerDeath.connect(HitReset)
	player.OnPlayerHit.connect(PlayerHit)
	
	
func PlayerHit(hurtboxHit:Hurtbox):
	if(hurtboxHit.owner is PlayerCharacter):
		HitEffect()
	
	
func CreateTimer() -> Timer:
	var t = Timer.new()
	t.one_shot = true
	t.autostart = false
	t.wait_time = duration
	add_child(t)
	return t
	
	
func StopHitEffect():
	if(isPlaying):
		timer.stop()
		HitReset()
	
func HitEffect(_duration:float = duration):
	WriteText()
	
	if(useAlphaFlicker):
		HitFlicker(_duration)
		return
	
	print("START HIT EFFECT")
	if(isPlaying):
		timer.stop()
		
	timer.start(_duration)
	
	isPlaying = true
	
	while timer.time_left > 0.0:
		var _timeProgress = _duration - timer.time_left 
		var _ratio = _timeProgress/_duration
		var _curveValue = alphaCurve.sample(_ratio)
		var _alpha = lerp(0.0,1.0,_curveValue)
		modulate.a = _alpha
		
		#print("HIT EFFECT ALPHA = " + str(_alpha))
		
		if !is_instance_valid(get_tree()):
			return
		
		await get_tree().process_frame
		
	HitReset()
	
func HitFlicker(_duration:float = duration):
	print("START HIT EFFECT")
	if(isPlaying):
		timer.stop()
		
	timer.start(_duration)
	WriteText()
	isPlaying = true
	
	var display = true
	
	while timer.time_left > 0.0:
		var _timeProgress = _duration - timer.time_left 
		var _ratio = _timeProgress/_duration
		
		
		if !is_instance_valid(get_tree()):
			return
		
		modulate.a = float(display) 
		print(str(float(display)))
		await get_tree().create_timer(flickerDisplayDuration,true,false,true).timeout
		display = !display
		
	HitReset()
	
	
func HitReset():
	modulate.a = 0.0
	isPlaying = false
	print("RESET HIT EFFECT")
	
func WriteText(_text:String = text):
	var currentText = ""
	label.text = currentText
	
	for letter in _text:
		currentText += letter
		label.text = currentText
		await get_tree().create_timer(timeByChar,true,false,true).timeout
		
	
