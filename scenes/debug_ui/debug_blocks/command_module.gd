class_name CommandModule
extends Resource
## Logic module designed to manage all processes and information related to running
## commands through the debug terminal.
##
## Contains a list of accepted commands and the logic for detecting and executing each.

## Dictionary mapping command names to corresponding information, structured as `CommandConfig` instances, as defined below.
var commands : Dictionary[StringName, CommandConfig] = {
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
	),
	"restart": CommandConfig.new( # NOTE: this kills the debug controls for now, will figure out why later
			"Restarts the game and clears all global variables",
			"None",
			["restart"]
	)
}

## Primary function for initiating a command from the terminal, or reporting an error if no matching command is found.
func run(full_command : String) -> void:
	var params = Array(full_command.split(' '))
	var command_name = params.pop_front()
	var signal_name = 'command_' + command_name
	if Events.has_signal(signal_name):
		DebugNode.print(full_command)
		Events[signal_name].emit(params)
	else:
		DebugNode.print("ERROR: Command '" + command_name + "' Not found. Run 'help' for a list of commands")


# Function for logging the `commands` dictionary to the terminal in a human readable form, as the result of the `help` command.
func help() -> void:
	var result = []
	for key in commands.keys():
		result.append(key)
		result.append(commands[key].to_string())
	DebugNode.print(result)

## Class representing a single command: its name, parameters, and examples of its usage.
class CommandConfig:
	## Description of the command and its utility.
	var description : String
	## Expected parameters of the command, and a brief description of each.
	var parameters : String
	## Examples of how to use the command.
	var examples : Array[String]

	func _init(cc_description := "No description provided", cc_parameters := "None", cc_examples : Array[String] = []):
		description = cc_description
		parameters = cc_parameters
		examples = cc_examples
	
	func _to_string() -> String:
		return "-- " + description + '\n-- Parameters: ' + parameters + '\n-- e.g. ' + ', '.join(examples)