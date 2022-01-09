extends KinematicBody2D

export var speed = 30

var velocity = Vector2.ZERO

onready var tween = $Tween

puppet var puppet_position = Vector2.ZERO setget puppet_position_set



func _physics_process(delta):
	if is_network_master():
		get_input()
		

func get_input():
	var x_in = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var y_in = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	velocity = Vector2(x_in, y_in).normalized()
	#print(global_position)
	move_and_slide(velocity * speed)

func _on_Net_Tick_Rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)

func puppet_position_set(new_value):
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()
	
	
