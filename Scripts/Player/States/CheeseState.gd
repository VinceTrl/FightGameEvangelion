extends PlayerState

@export var cheeseDuration:float = 10.0
@onready var kiki_cheese: Node3D = $"../../KikiCheese"
@onready var sprite_2d: Sprite3D = $"../../Sprite2D"

var reset:bool = false

func EnterState():
	Name = "Cheese"
	sprite_2d.visible = false
	kiki_cheese.visible = true
	reset = false
	
	#first time effects
	if(!Player.isCheese):
		Manager.gameCamera.FocusTargetZoom(Player,Manager.gameCamera.GetZoomParamFromName("HitZoom"))
		Manager.timeManager.freezeFrame(0.001,0.3)
		Player.sprite.HitColorEffect()
		Player.nodeShaker.NodeShake()
		Manager.gameCamera.camShake.AskCamShake("HitShake")
		Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"HurtVibration")
		pass
	Player.StartCheeseState()
	
	
	
	
	
func ExitState():
	sprite_2d.visible = true
	kiki_cheese.visible = false
	pass

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleFalling()
	Player.HandleGravity(delta,Player.jumpGravity)
	Player.HorizontalMovement()
	Player.HandleJump()
	#Player.HandleDash()
	#Player.HandleAttack()
	#Player.HandleShoot()
	HandleLanding()
	
func HandleLanding():
	if(reset):return
	
	if(Player.is_on_floor()):
		Player.ResetJump()
		reset = true
	pass
