extends Node

@warning_ignore_start("unused_signal")

## Emitted when the player clicks the new run button
signal new_run_started()

## Emitted when the player clicks into a new match from the map screen
signal match_started(encounter : EncounterRes)

## Emitted when the player wins a match and returns to the map screen
signal match_won()