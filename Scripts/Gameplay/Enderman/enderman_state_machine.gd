extends CharacterStateMachine

@onready var Idle: CharacterState = $Idle
@onready var Teleport: CharacterState = $Teleport
@onready var Hurt: CharacterState = $Hurt
@onready var Steal: CharacterState = $Steal
@onready var Drop: CharacterState = $Drop
@onready var Death: CharacterState = $Death
