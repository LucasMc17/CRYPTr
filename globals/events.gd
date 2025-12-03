extends Node

@warning_ignore_start("unused_signal")

# RUN LIFECYCLE

## Emitted when the player clicks the new run button
signal new_run_started()

## Emitted when the player clicks into a new match from the map screen
signal match_started(encounter : EncounterRes)

## Emitted when the player wins a match, typically combined with return_to_map
signal match_won()

## Emitted when the player leaves an encounter and returns to the map
signal return_to_map(new_map : bool)

## Emitted when a match is lost, forfeiting the run
signal run_lost()

# ENCOUNTER LIFECYCLE

## Emitted when the user left clicks on a cryptograph
signal cryptograph_left_clicked(cryptograph_scene : Cryptograph)

## Emitted when the user right clicks on a cryptograph, typically in order to discard it
signal cryptograph_right_clicked(cryptograph_scene : Cryptograph)

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