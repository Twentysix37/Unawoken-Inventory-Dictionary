extends State
class_name Enemy_Attack

@export var SelfRef : BasicEnemy

func OnEnter():
	print("Attacking")
	SelfRef.velocity = Vector2.ZERO
	SelfRef.AnimPlayer.play("Skeleton_Attack")
	await SelfRef.AnimPlayer.animation_finished
	
	if SelfRef.PlayerTarget != null:
		var Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
		if SelfRef.CurrentHealth >= 1:
			if Direction.length() < SelfRef.DetectionRange:
				Transitioned.emit("Follow")
			else:
				Transitioned.emit("Idle")
			
func Update(delta : float):
	if SelfRef.CurrentHealth <= 0:
		Transitioned.emit("Dead")
	
