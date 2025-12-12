extends Node
## Run-level information.

# RUN CONSTANTS

## How much to add to the length multiplier for each character of the word being scored.
const LENGTH_MULTIPLIER := 0.2
## Minimum length to consider a word valid.
const MINIMUM_WORD_LENGTH := 3
## Size of the player's hand at maximum.
const HAND_SIZE := 6

const BASE_DISCARDS := 10

const BASE_PALINDROGRAM_MULT := 3.0
const BASE_SEMORDNIGRAM_MULT := 2.0
const BASE_EQUIGRAM_MULT := 1.5
const BASE_ISOGRAM_MULT := 2.0
const BASE_PANGRAM_MULT := 3.0
const BASE_ANAGRAM_MULT := 2.0
const BASE_PERFECTIGRAM_MULT := 5.0
const BASE_REDUPLIGRAM_MULT := 3.0
const BASE_AMBIGRAM_MULT := 4.0
const BASE_GYROGRAM_MULT := 5.0

# RUN MEMORY

var discards := BASE_DISCARDS

var palindrogram_mult := BASE_PALINDROGRAM_MULT
var semordnigram_mult := BASE_SEMORDNIGRAM_MULT
var equigram_mult := BASE_EQUIGRAM_MULT
var isogram_mult := BASE_ISOGRAM_MULT
var pangram_mult := BASE_PANGRAM_MULT
var anagram_mult := BASE_ANAGRAM_MULT
var perfectigram_mult := BASE_PERFECTIGRAM_MULT
var redupligram_mult := BASE_REDUPLIGRAM_MULT
var ambigram_mult := BASE_AMBIGRAM_MULT
var gyrogram_mult := BASE_GYROGRAM_MULT

## The Deck/Stack for the current run.
var stack : Array[CryptographRes] = []
## The stack as currently initted, shuffled and drawn from in the current encounter.
var current_stack : Array[CryptographRes] = []
## Memory of played words, alphabetized to easily check for anagrams.
var anagrams : Dictionary[String, Dictionary] = {}
## The current map, from the root encounter node.
var encounter_map : EncounterRes = null
## The current encounter from the encounter map.
var current_encounter : EncounterRes = null

## Resets all the run variables to their default value so that a new run can begin from a clean slate.
func reset_run() -> void:
	palindrogram_mult = BASE_PALINDROGRAM_MULT
	semordnigram_mult = BASE_SEMORDNIGRAM_MULT
	equigram_mult = BASE_EQUIGRAM_MULT
	isogram_mult = BASE_ISOGRAM_MULT
	pangram_mult = BASE_PANGRAM_MULT
	anagram_mult = BASE_ANAGRAM_MULT
	perfectigram_mult = BASE_PERFECTIGRAM_MULT
	redupligram_mult = BASE_REDUPLIGRAM_MULT
	ambigram_mult = BASE_AMBIGRAM_MULT
	gyrogram_mult = BASE_GYROGRAM_MULT

	discards = BASE_DISCARDS

	stack.clear()
	current_stack.clear()
	anagrams.clear()
	encounter_map = null
	current_encounter = null


## Adds the characters of the inputted word as a key in the anagrams dict.
func add_anagram(word : String) -> void:
	var alpha = word.split()
	alpha.sort()
	var key = "".join(alpha)

	if anagrams.has(key):
		anagrams[key][word] = true
	else:
		anagrams[key] = {word: true}


## Initializes the stack from a StarterStack resource. Effectively converts it to an array of cryptograph resources.
func initialize_stack(starter_stack : StarterStack):
	var alpha = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
	var result : Array[CryptographRes] = []
	for character in alpha:
		if starter_stack[character] > 0:
			var cryptograph = load('res://resources/cryptographs/' + character + '_cryptograph.tres')
			for i in range(starter_stack[character]):
				result.append(cryptograph.duplicate())
	stack = result