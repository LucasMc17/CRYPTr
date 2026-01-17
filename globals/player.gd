extends Node
## Run-level information.

# RUN CONSTANTS

## How much to add to the length multiplier for each character of the word being scored.
const LENGTH_MULTIPLIER := 0.2
## Minimum length to consider a word valid.
const MINIMUM_WORD_LENGTH := 3
## Size of the player's hand at maximum.
const HAND_SIZE := 6
## The maximum Hooks which a player can have installed at a time.
const MAX_HOOKS := 5
## The maximum Functions which a player can have available to distribute to Functions.
const MAX_FUNCTIONS := 10

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

## The current state of the game, as in map, encounter, shop, etc.
var game_state : String

## The Deck/Stack for the current run.
var stack : Array[CryptographRes] = []
## The stack as currently initted, shuffled and drawn from in the current encounter.
var current_stack : Array[CryptographRes] = stack
## Memory of played words, alphabetized to easily check for anagrams.
var anagrams : Dictionary[String, Dictionary] = {}
## The current map, from the root encounter node.
var encounter_map : EncounterRes = null
## The current encounter from the encounter map.
var current_encounter : EncounterRes = null
## The player's currently collected Hooks.
var hooks : Array[Hook] = []
## The player's currently collected Functions.
var functions : Array[Function] = []
## The player's currently collected Executables.
var executables : Array[Executable] = []
## The player's money.
var money := 0

func _ready():
	Events.shadow_executed.connect(_on_shadow_used)

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
	current_stack = stack
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
func initialize_stack(starter_stack : StarterStack) -> void:
	var alpha = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
	var result : Array[CryptographRes] = []
	for character in alpha:
		if starter_stack[character] > 0:
			var cryptograph = load('res://resources/cryptographs/' + character + '_cryptograph.tres')
			for i in range(starter_stack[character]):
				result.append(cryptograph.duplicate())
	stack = result
	current_stack = stack


## Change the player's money by a set amount, positive or negative, and fire global event to update UI.
func change_money(amount : int) -> void:
	money += amount
	Events.emit_money_changed(amount)


## Remove an Executable from player inventory.
func remove_executable(exe : Executable) -> void:
	executables = executables.filter(func (executable): return executable != exe)
	Events.refresh_executables.emit()
	Events.refresh_executable_access.emit()

func add_executable(exe : Executable) -> void:
	executables.append(exe)
	Events.refresh_executables.emit()
	Events.refresh_executable_access.emit()

func _on_shadow_used(shadow : Executable):
	var candidates = executables.filter(func (exe): return exe != shadow)
	var index = randi_range(0, candidates.size() - 1)
	var copy = candidates[index].duplicate()
	add_executable(copy)
