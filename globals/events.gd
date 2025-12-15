extends Node

@warning_ignore_start("unused_signal")

# RUN LIFECYCLE

## Emitted when the player clicks the new run button
signal new_run_started()

## Emitted when the player clicks into a new match from the map screen.
## Pass with an object matching this signature: { "encounter": EncounterRes }
signal match_started(params : Dictionary[StringName, EncounterRes])

## Emitted when the player wins a match, typically combined with return_to_map
signal match_won()

## Emitted when the player leaves an encounter and returns to the map.
## Pass with an object matching this signature: { "new_map": bool }
signal return_to_map(params : Dictionary[StringName, bool])

## Emitted when a match is lost, forfeiting the run
signal run_lost()

## Emitted when a run is paused.
## Pass with an object matching this signature: { "menu_screen": StringName }
signal paused(params : Dictionary[StringName, StringName])

## Emitted when a run is unpaused
signal unpaused()

## Emitted when the user elects to quit to the main menu of the game.
signal quit_to_menu()

# ENCOUNTER LIFECYCLE

## Emitted when the user left clicks on a cryptograph.
## Pass with an object matching this signature: { "cryptograph_scene": Cryptograph }
signal cryptograph_discarded(params : Dictionary[StringName, Cryptograph])

## Emitted on each letter of the scored word in sequence.
## Pass with an object matching this signature: { "letter": StringName }
signal letter_scored(params : Dictionary[StringName, StringName])

# DEBUG COMMANDS

## Emitted when the help command is issued
signal command_help(params : Array[String])

## Emitted when the echo command is issued
signal command_echo(params : Array[String])

## Emitted when the win command is issued
signal command_win(params : Array[String])

## Emitted when the lose command is issued
signal command_lose(params : Array[String])

## Emitted when the clear command is issued
signal command_clear(params : Array[String])

## Emitted when the exit command is issued
signal command_exit(params : Array[String])

## Emitted when the restart command is issued
signal command_restart(params : Array[String])