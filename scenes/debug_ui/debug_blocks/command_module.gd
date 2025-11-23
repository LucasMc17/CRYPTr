class_name CommandModule extends Node
# "echo": {
# 		"logic": func(message): 
# 			if message.size() == 1:
# 				message = message[0]
# 			return message,
# 		"description": "Prints a message to the console.",
# 		"parameters": "Pass any text following the command to echo it to the console",
# 		"examples": ["echo this", "echo that", "echo this and that"]
# 	},

class CommandConfig:
	var description : String
	var parameters : String
	var examples : Array[String]

	func _init(des := "No description provided", params := "None", ex : Array[String] = []):
		description = des
		parameters = params
		examples = ex
	
	func _to_string() -> String:
		return "-- " + description + '\n-- Parameters: ' + parameters + '\n-- e.g. ' + ', '.join(examples)

var COMMANDS : Dictionary[StringName, CommandConfig] = {
	"help": CommandConfig.new(
		"Logs to the console all available commands, their descriptions, expected parameters, and examples of how to use them",
		"None",
		["help"]
	),
	"echo": CommandConfig.new(
		"Prints a message to the console",
		"Pass any text following the command to echo it to the console",
		["echo this", "echo that", "echo this and that"]
	),
	"win": CommandConfig.new(
		"Instantly wins the current encounter",
		"None",
		["win"]
	),
	"lose": CommandConfig.new(
		"Instantly loses the current encounter",
		"None",
		["lose"]
	),
	"clear": CommandConfig.new(
		"Clears the debug console",
		"None",
		["clear"]
	),
	"exit": CommandConfig.new(
		"Instantly exits the game and ends the process",
		"None",
		["exit"]
	)
}

func run(full_command : String) -> void:
	var params = Array(full_command.split(' '))
	var command_name = params.pop_front()
	var signal_name = 'command_' + command_name
	if Events.has_signal(signal_name):
		DebugNode.print(full_command)
		Events[signal_name].emit(params)
	else:
		DebugNode.print("ERROR: Command '" + command_name + "' Not found. Run 'help' for a list of commands")
	
func help():
	var result = []
	for key in COMMANDS.keys():
		result.append(key)
		result.append(COMMANDS[key].to_string())
	DebugNode.print(result)