extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 25565
const MAX_PLAYERS = 20

var self_data = { name = ''}
var goalIP = "127.0.0.1"
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print("Player connected to the server!")
	globals.current_player_count += 1
	globals.players[id] = id #Turn into a player name
	print("Current player count: " + str(globals.current_player_count))
	
	#Remove this code
	#var game = preload("res://Core/Game.tscn").instance()
	#get_tree().get_root().add_child(game)
	#hide()

func _player_disconnected(id):
	print("Player disconnected from the server :(")
	globals.current_player_count -= 1
	globals.players.erase(id)

func _on_buttonHost_pressed():
	print("Hosting network with IP: " + str(goalIP))
	print("Server is on port: " + str(DEFAULT_PORT))
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(DEFAULT_PORT, MAX_PLAYERS)
	if res != OK:
		print("Error creating server")
		return
		
	globals.current_player_count += 1
	$buttonJoin.hide()
	$IPLabel.hide()
	$IPValue.hide()
	$buttonHost.disabled = true
	$LaunchMatch.show()
	$LaunchMatch.disabled = false
	get_tree().set_network_peer(host)

func _on_buttonJoin_pressed():
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	host.create_client(goalIP,DEFAULT_PORT)
	get_tree().set_network_peer(host)
	$buttonHost.hide()
	$buttonJoin.disabled = true


func _on_IPValue_text_changed():
	goalIP = $IPValue.text
	print(str(goalIP))


func _on_LaunchMatch_pressed():
	var game = preload("res://Core/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()