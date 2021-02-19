extends Node2D

onready var VP = get_viewport().get_visible_rect().size
const VEL_MUL = 5.0

var rng = RandomNumberGenerator.new()
var dir = 0.0
var vel = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	dir = rng.randf_range(0.0, 359.9)
	self.rotation_degrees = dir
	vel.x = cos(dir*PI/180.0)*VEL_MUL
	vel.y = sin(dir*PI/180.0)*VEL_MUL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	# bounding x box
	if self.position.x > VP.x:
		vel.x = -vel.x
		self.position.x = VP.x
	elif self.position.x < 0:
		vel.x = -vel.x
		self.position.x = 0
		
	# bounding y box
	elif self.position.y > VP.y:
		vel.y = -vel.y
		self.position.y = VP.y
	elif self.position.y < 0:
		vel.y = -vel.y
		self.position.y = 0
		
		
	self.position.x += vel.x
	self.position.y += vel.y

onready var Player = get_node("/root/Game/Spaceship_Player") 
onready var global = get_node("/root/Global")
onready var ScoreTextNode = get_node("/root/Game/Score")
func _on_EnemyArea2d_area_entered(area):
	if area.collision_mask == 3: # player
		Player.DestroyPlayer()
		
	elif area.collision_mask == 9: # bullet
		# get rid of the bullet and the enemy when they collide
		area.owner.queue_free() # owner of the "area" local is the Bullet node.
		queue_free()
		global.score += 1
		ScoreTextNode.text = "Score: " + str(global.score)
		if global.score >= global.score_to_win:
			get_tree().change_scene("res://Scenes/Win.tscn")
		
		
	
