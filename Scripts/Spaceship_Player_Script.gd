extends Area2D

const VEL_STEP = 5.0

var VEL_MUL = 1.0


const BOOST_METER_DEC = 0.05
const BOOST_METER_INC = 0.1
const BOOST_METER_MAX = 10.0
var BOOST_METER = BOOST_METER_MAX
var is_replenishing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
const delta_offset_mul = 60 # multiply by 60(fps) to offset the fact that multiplying by delta makes the value super small
func _physics_process(delta):
	handleBoost()
	handleVelocity(delta)

func _on_Station_Bound_area_entered(_area):
	is_replenishing = true
func _on_Station_Bound_area_exited(_area):
	is_replenishing = false



func handleBoost():
	var boost_fire_node = get_node("Boost_Fire")
	if Input.is_action_pressed("modifier") and BOOST_METER > 0.0:
		if not boost_fire_node.visible:
			boost_fire_node.visible = true
		VEL_MUL = 1.5
		BOOST_METER -= BOOST_METER_DEC
	else:
		if boost_fire_node.visible:
			boost_fire_node.visible = false
		VEL_MUL = 1.0
	var boost_node = get_node("../Boost")
	boost_node.text = "Energy: " + str(BOOST_METER)
	
	if is_replenishing and BOOST_METER < BOOST_METER_MAX:
		BOOST_METER += BOOST_METER_INC
	
func handleVelocity(delta):
	var velocity = (VEL_STEP*delta_offset_mul) * delta * VEL_MUL
	var velocity_vec = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("ui_right"):
		velocity_vec.x += velocity
	if Input.is_action_pressed("ui_left"):
		velocity_vec.x -= velocity
	if Input.is_action_pressed("ui_up"):
		velocity_vec.y -= velocity
	if Input.is_action_pressed("ui_down"):
		velocity_vec.y += velocity
		
	self.position.x += velocity_vec.x
	self.position.y += velocity_vec.y
		
	# rotate spaceship to whatever direction we're going in
	if not abs(velocity_vec.x) + abs(velocity_vec.y) == 0:
		self.rotation_degrees = atan2(velocity_vec.x, -velocity_vec.y) * (180 / PI)
		
		
func DestroyPlayer():
	queue_free()
	get_tree().change_scene("res://Scenes/GameOver.tscn")
