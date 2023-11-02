extends State
class_name Player_Idle

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer

func Update(delta : float):
	match PlayerRef.CurrentDirection:
		0:
			AnimPlayer.play("Idle_Up")
		1:
			AnimPlayer.play("Idle_Down")
		2:
			AnimPlayer.play("Idle_Left")
		3:
			AnimPlayer.play("Idle_Right")
			
	if PlayerRef.CurrentSpeed > 0.1:
		Transitioned.emit(self, "Player_Move")