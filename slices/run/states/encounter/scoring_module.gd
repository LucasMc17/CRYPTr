class_name ScoringModule extends Node

# EXPORTS
@export_group("Scoring Constants")
@export var length_multiplier := 0.2
@export var minimum_word_length := 3

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

class ScoringObject:
	var valid : bool
	var base_score : float
	var length_mult : float
	var word_name : String
	var additional_mults : Dictionary[String, float] = {}
	var total_score : float

	func to_object():
		return {
			"valid" : valid,
			"base_score": base_score,
			"length_mult": length_mult,
			"word_name": word_name,
			"additional_mults": additional_mults,
			"total_score": total_score
		}

# MEMORY
var anagrams = {}

# WORD UTILITIES
func get_word_name(word : String):
	var prefix_map = {
		3: 'tri',
		4: 'tetra',
		5: 'penta',
		6: 'hexa',
		7: 'hepta',
		8: 'octa',
		9: 'ennea',
		10: 'deca',
		11: 'hendeca',
		12: 'dodeca',
		13: 'triskaideca',
		14: 'tetrakaideca',
		15: 'pentakaideca',
		16: 'hexakaideca',
		17: 'heptakaideca',
		18: 'octakaideca',
		19: 'enneakaideca',
		20: 'icosa',
	}
	var length = word.length()
	if length < minimum_word_length:
		return
	if length < 21:
		var prefix = prefix_map[length]
		return prefix + 'gram'
	return 'ICOSA++++'

func flip_word(word : String):
	var gyro_map = {
		"W": "M",
		"I": "I",
		"O": "O",
		"S": "S",
		"H": "H",
		"Z": "Z",
		"X": "X",
		"N": "N",
		"M": "W"
	}
	var flipped = word.reverse()
	for i in range(flipped.length()):
		if !gyro_map.has(flipped[i]):
			return false
		flipped[i] = gyro_map[flipped[i]]
	return flipped

func is_valid(word : String) -> bool:
	# Word is in dictionary
	if word.length() < minimum_word_length:
		return false
	if DebugNode.ACCEPT_ALL_WORDS:
		return true
	var first_letter = word[0]
	var words = FileAccess.open('res://words/' + first_letter + '.txt', FileAccess.READ).get_as_text().split('\n')
	return words.has(word)

# WORD BONUS DETECTORS
func is_palindrogram(word : String) -> bool:
	# Word is the same forward and backward
	return word.reverse() == word

func is_semordnigram(word : String) -> bool:
	# Word is still valid when reversed
	return is_valid(word.reverse())

func is_equigram(word : String) -> bool:
	# Word's vowel count equals its consonant count
	var vowels = 0
	var cons = 0
	for letter in word:
		if ['A', 'E', 'I', 'O', 'U'].has(letter):
			vowels += 1
		else:
			cons += 1
	return vowels == cons

## Word uses every letter in hand at least once, and hand has the full Cryptograph count
func is_pangram(word : String, letters : Array) -> bool:
	if word.length() < 6:
		return false
	for character in letters:
		if !word.contains(character):
			return false
	return true

## Word uses every letter in hand exactly once, and hand has the full Cryptograph count
func is_perfectigram(word : String) -> bool:
	return word.length() == 6

func is_isogram(word : String) -> bool:
	# Word uses each of its letters exactly once
	var map = []
	for letter in word:
		if map.has(letter):
			return false
		else:
			map.append(letter)
	return true

func is_anagram(word) -> bool:
	# Word is an anagram of a previously played word
	var alpha = word.split()
	alpha.sort()
	alpha = "".join(alpha)
	
	if anagrams.has(alpha):
		# TODO: need to add to the dictionary at time of word submission
		return true
	else:
		return false

func is_redupligram(word : String) -> bool:
	# Word consists of two or three identical segments, e.g. CANCAN, TUTU
	var length = word.length()
	if length % 2 == 0:
		var one = word.left(-1 * (length / 2))
		var two = word.right(-1 * (length / 2))
		if one == two:
			return true
	if length % 3 == 0:
		var one = word.left(-1 * (length / 3 * 2))
		var two = word.left(-1 * (length / 3)).right(-1 * (length / 3))
		var three = word.right(-1 * (length / 3 * 2))
		if one == two and two == three:
			return true
	return false

# SCORING
func get_base_score(word : String, hand : Array[Cryptograph]) -> float:
	var score = 0.0
	for character in word:
		var applicable = hand.filter(func(cryptograph): return cryptograph.RESOURCE.letter.character == character)
		score += applicable.reduce(func(accum, cryptograph): return accum + cryptograph.RESOURCE.letter.points, 0.0)
	return score

func get_length_mult(word : String) -> float:
	return 1 + length_multiplier * word.length()

func create_scoring_object(word : String, hand : Hand) -> ScoringObject:
	var result = ScoringObject.new()
	result.valid = is_valid(word)
	if !result.valid:
		return result
	var cryptographs = hand.cryptographs
	var letters = hand.letters
	result.base_score = get_base_score(word, cryptographs)
	result.length_mult = get_length_mult(word)
	result.word_name = get_word_name(word)

	# Palindrogram/Semordnigram check
	if is_palindrogram(word):
		result.additional_mults.palindrogram = palindrogram_mult
	elif is_semordnigram(word):
		result.additional_mults.semordnigram = semordnigram_mult
	
	# Equigram check
	if is_equigram(word):
		result.additional_mults.equigram = equigram_mult
	
	# Perfectigram/Pangram/Isogram check
	if is_pangram(word, letters):
		if is_perfectigram(word):
			result.additional_mults.perfectigram = perfectigram_mult
		else:
			result.additional_mults.pangram = pangram_mult
	elif is_isogram(word):
		result.additional_mults.isogram = isogram_mult
	
	# Redupligram check
	if is_redupligram(word):
		result.additional_mults.redupligram = redupligram_mult
	
	# Gyrogram/Ambigram check
	var flipped = flip_word(word)
	if flipped:
		if flipped == word:
			result.additional_mults.gyrogram = gyrogram_mult
		elif is_valid(flipped):
			result.additional_mults.ambigram = ambigram_mult

	var total_score = result.base_score * result.length_mult
	for mult in result.additional_mults:
		total_score *= result.additional_mults[mult]
	result.total_score = total_score

	return result
