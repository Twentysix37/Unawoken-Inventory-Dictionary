extends RigidBody2D
class_name Coin

func _ready():
	TimeDestroy()

#If coin is not picked up by the end of its random lifespan; delete and add 1 to coin count
func TimeDestroy():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var newTime = RNG.randf_range(2.5, 5.0)
	await get_tree().create_timer(newTime).timeout
	if self.is_inside_tree():
		var player = get_tree().get_first_node_in_group("Player")
		if player is Player:
			player.InventoryRef.CoinCount += 1
		self.queue_free()

#Add to coin count on collision
func OnPickup(body : Node2D):
	if body is Player:
		body.InventoryRef.CoinCount += 1
		self.queue_free()
