extends Node

@warning_ignore_start("unused_signal")

# RUN LIFECYCLE

## Emitted when the player clicks the new run button
signal new_run_started()

## Emitted when the player clicks into a new match from the map screen
signal match_started(encounter : EncounterRes)

## Emitted when the player wins a match and returns to the map screen
signal match_won()

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