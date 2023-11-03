extends State
class_name Enemy_Idle

@export var SelfRef : BasicEnemy
var ChangeTime : float

func OnEnter():
	print("Skeleton: IDLE")
	ChangeTime = 3.0

func Update(delta : float):
	if SelfRef.AnimPlayer:
		SelfRef.AnimPlayer.play("Skeleton_Idle")
		
	if ChangeTime > 0:
		ChangeTime -= delta
	else:
		ChangeToWander()
		
func PhysicsUpdate(_delta : float):
	if SelfRef.PlayerTarget != null:
		var Direction = SelfRef.PlayerTarget.global_position - SelfRef.global_position
	
		if Direction.length() < SelfRef.DetectionRange:
			Transitioned.emit("Follow")
	
func ChangeToWander():
	var RNG = RandomNumberGenerator.new()
	var newValue = RNG.randf_range(0, 1.0)
	
	if newValue <= 0.75:
		print("Transitioning to WANDER")
		Transitioned.emit("Wander")
	else:
		print("Staying in Idle")
		ChangeTime = RNG.randf_range(0, 5)
	
