extends Node


const IP_SERVER = '127.0.0.1'
const PORT_SERVER = 36999

var is_connected = false

# Player info, associate ID to data
var players = {}
var my_info = {name = '', mensage = ''}

signal send_message(id, msg)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func login_server(nick):
	my_info.name = nick
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(IP_SERVER, PORT_SERVER)
	get_tree().network_peer = peer

func unlogin():
	get_tree().network_peer = null
	_server_disconnected()

	# Recebe sinal dos nos conectados e envia sua informações
func _player_connected(id):
	if not(get_tree().is_network_server()):
		print("::: ",id)
		rpc_id(id, '_request_player_info_to_server', my_info)
		
func _request_player_info_to_server(info):
	pass

func send_msg(msg_id):
	rpc_id(1, '_request_message', msg_id)

remote func _request_player_info(id, info):
	players[id] = info
	print("Players: ", players)
		
remote func _send_player_info(id, info):
	print("ID: ", id, " envia ", info)
	pass
	
remote func _send_message(id, message):
	emit_signal("send_message", id, message)

func _player_disconnected(id):
	players.erase(id) # Erase player from info.
	
func _connected_ok():
	print("_connected_ok")
	is_connected = true
	
func _connected_fail():
	print('_connected_fail')

func _server_disconnected():
	# Servidor disconectado
	print("_server_disconnected")
	is_connected = false



