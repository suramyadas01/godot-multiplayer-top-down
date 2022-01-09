extends Control

onready var multiplayer_ui = $Multiplayer_Configure
onready var server_ip = $Multiplayer_Configure/LineEdit

onready var device_ip_address = $CanvasLayer/ip_address
var player = preload("res://SCENES/Player.tscn")

func _ready():
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")

	device_ip_address.text = Network.ip_address
	
func _player_connected(id):
		instance_player(id)
		print("Player" + str(id) + "has connected")

	
func _player_disconnected(id):
	print("Player" + str(id) + "has disconnected")
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()
	
func _on_Create_Server_pressed():
	multiplayer_ui.hide()
	Network.create_server()
	instance_player(get_tree().get_network_unique_id())

func _on_Join_Server_pressed():
	if server_ip.text != "":
		multiplayer_ui.hide()
		Network.ip_address = server_ip.text
		Network.join_server()

func _connected_to_server():
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())

func instance_player(id):
	var player_instance = Globals.instance_node_at_location(player, Players, Vector2(rand_range(50, 400), rand_range(50, 300)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
