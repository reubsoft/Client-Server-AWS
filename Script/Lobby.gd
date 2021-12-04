extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$UI/Name.text = 'cliente_'+str(randi() % 9000)
	Network.connect("send_message", self, "_writeText")

func _process(delta):
	is_connect()

func _writeText(id,  message):
	$UI_CONECT/Painel.text += 'USER: ' +str(id) +" [ "+ message + ' ] \n'

func is_connect():
	if Network.is_connected:
		$Status.text = "Conectado"
		$UI.visible = false
		$UI_CONECT.visible = true
		if not is_network_master():
			set_network_master(get_tree().get_network_unique_id())
	else:
		$Status.text = "Desconectado"
		$UI.visible = true
		$UI_CONECT.visible = false


func _on_login_button_down():
	if $UI/Name.text != "":
		Network.login_server($UI/Name.text)

func _on_Desconnected_button_down():
	Network.unlogin()
	pass # Replace with function body.

func _on_Enviar_button_down():
	var message = $UI_CONECT/Msg.text
	$UI_CONECT/Msg.text = ''
	$UI_CONECT/Painel.text += "Você : [ " + message + ' ] \n'
	Network.send_msg(message)
