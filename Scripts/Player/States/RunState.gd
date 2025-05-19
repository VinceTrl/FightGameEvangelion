extends PlayerState

const SD_FOOTSTEPS = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_footsteps.wav")
@onready var sfx_move: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Move"

func EnterState():
	Name = "Run"
	Player.animator.play("Move")
	
	#Footsteps sounds
	sfx_move.stream = SD_FOOTSTEPS
	var ranStart = randf_range(0.0,sfx_move.stream.get_length())
	sfx_move.play(ranStart)
	
func ExitState():
	sfx_move.stop()

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleFalling()
	Player.HorizontalMovement()
	Player.HandleJump()
	Player.HandleDash()
	Player.HandleAttack()
	Player.HandleShoot()
	
	
	HandleAnimations()
	HandleIdle()
	

func HandleIdle():
	if (Player.moveDirectionX == 0):
		Player.ChangeState(States.Idle)

func HandleAnimations():
	Player.HandleFlipH()
