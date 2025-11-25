## Run-level information
extends Node

## The Deck/Stack for the current run
var STACK : Array[CryptographRes] = []

# @export_group("Scoring Constants")
# @export var length_multiplier := 0.2
# @export var minimum_word_length := 3

## The multipliers for various word types
@export_group("Word Type Multipliers")
@export var palindrogram_mult := 3.0
@export var semordnigram_mult := 2.0
@export var equigram_mult := 1.5
@export var isogram_mult := 2.0
@export var pangram_mult := 3.0
@export var perfectigram_mult := 5.0
@export var redupligram_mult := 3.0
@export var ambigram_mult := 4.0
@export var gyrogram_mult := 5.0

# Run memory

var anagrams := {}

var ENCOUNTER_MAP : EncounterRes
var CURRENT_ENCOUNTER : EncounterRes
var DISCARDS := 10

# func initialize_stack(starter_stack: StarterDeckRes) -> void:
# 	var result : Array[CryptographRes] = []
# 	for cryptograph in starter_stack.cryptographs:
# 		result.append(cryptograph.duplicate())
# 	STACK = result

func initialize_stack(starter_stack : StarterStack):
	var alpha = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
	var result : Array[CryptographRes] = []
	for character in alpha:
		if starter_stack[character] > 0:
			var cryptograph = load('res://resources/cryptographs/' + character + '_cryptograph.tres')
			for i in range(starter_stack[character]):
				result.append(cryptograph.duplicate())
	STACK = result