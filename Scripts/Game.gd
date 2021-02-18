extends Node2D

onready var global = get_node("/root/Global")

func _ready():
	var ScoreNode = get_node("/root/Game/Score")
	ScoreNode.text = "Score: " + str(global.score)
	spawn_enemy_child()

func _on_EnemySpawn_timeout():
	spawn_enemy_child()

onready var VP = get_viewport().get_visible_rect().size

func spawn_enemy_child():
	var Enemies = load("res://Scenes/Enemies.tscn")
	var enemy = Enemies.instance()
	enemy.position.x = rand_range(0.0, VP.x)
	enemy.position.y = rand_range(0.0, VP.y)
	enemy.add_to_group("Enemies")
	add_child(enemy)

func _physics_process(_delta):
	handleShootBullet()
	
	
	
func handleShootBullet():
	if Input.is_action_just_pressed("fire"):
		var bullet_scene = load("res://Scenes/Bullet.tscn")
		var bullet = bullet_scene.instance()
		if Input.is_action_pressed("modifier") and get_node("/root/Game/Spaceship_Player").BOOST_METER > 0.0:
			bullet.is_homing = true
		add_child(bullet)
		


func _on_Button_pressed():
	get_tree().paused = not get_tree().paused
