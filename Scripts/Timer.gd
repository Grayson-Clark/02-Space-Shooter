extends Timer

func _on_EnemySpawn_timeout():
	self.wait_time += sin(self.wait_time)
