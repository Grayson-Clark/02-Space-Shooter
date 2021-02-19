extends Node2D

const BULLET_VEL = 6.0
const STEER_FORCE = 5.0 # how quickly the bullet should "home in" on the target

var is_homing = false
var lowest_dist_enemy = null # an enemy node of the closest enemy

onready var Player = get_node("../Spaceship_Player")
onready var Enemies = get_tree().get_nodes_in_group("Enemies")
onready var HomingTarget = load("res://Scenes/HomingTarget.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = Player.position.x
	self.position.y = Player.position.y
	self.rotation = Player.rotation
	get_node("UntilDestroy").start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if is_homing: # homing bullet - set rotation to point to enemy
		var lowest_dist = 99999.0
		for enemy in Enemies:
			if enemy != null:
				var delta_x = enemy.position.x - self.position.x
				var delta_y = enemy.position.y - self.position.y
				var hypotenuse = sqrt(pow(delta_x, 2) + pow(delta_y, 2))
				if hypotenuse < lowest_dist:
					lowest_dist_enemy = enemy
			
		if lowest_dist_enemy != null:
			if not lowest_dist_enemy.has_node("HomingTarget"):
				lowest_dist_enemy.add_child(HomingTarget)
			var enemy_pos = Vector2(lowest_dist_enemy.position.x, lowest_dist_enemy.position.y)
			look_at(enemy_pos)
			self.rotation_degrees += 90 # not sure why this is necessary... without it the bullet orients perpendicular to it's target enemy

	# move bullet forward in the direction it is facing
	var direction = Vector2(sin(self.rotation), cos(self.rotation))
	self.position.y -= direction.y * BULLET_VEL
	self.position.x += direction.x * BULLET_VEL


func _on_UntilDestroy_timeout():
	queue_free()
