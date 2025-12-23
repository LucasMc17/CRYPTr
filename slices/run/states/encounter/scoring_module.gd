class_name ScoringModule
extends Resource
## Logic module for determining validity of word and scoring it if valid.
##
## Also manages current and target scores, and compares them to check for a win.

## Player's current score in the active encounter.
var current_score := 0.0
## Current encounter's target score for comparison with player's score.
var target_score := 0.0
## The tally of points earned by the current word, as it is evaluated. Increases as each letter is scored/muliplier applied, then is added to `current_score`, then reset to zero.
var evaluating_score := 0.0:
	set(val):
		DebugNode.p(val)
		evaluating_score = val
## Whether a word is actively scoring.
var is_evaluating := false
## ScoringObject represenging the multipliers and total score of the current word before entry.
var score_object : ScoringObject

func _init():
	Events.subprocess_addition.connect(_on_subprocess_addition)
	Events.subprocess_multiplication.connect(_on_subprocess_multiplication)


## Updates the score_object with a new object based on word and hand.
func update_score_object(word : String, hand : Hand) -> void:
	score_object = ScoringObject.new(word, hand)


## Compares target score and current score to determine if the player has won.
func check_win() -> bool: 
	return current_score >= target_score


## Scores the word based on the cryptographs in hand.
func score_word(hand : Array[Cryptograph]) -> void:
	is_evaluating = true
	Player.add_anagram(score_object.word)
	# TODO: There will be even more to do with this when the animation queue is set up. yeesh
	for character in score_object.word:
		var applicable = hand.filter(func(cryptograph): return cryptograph.resource.letter.character == character)
		for cryptograph in applicable:
			evaluating_score += cryptograph.resource.letter.points
			## TODO: getting the character is cumbersome. Should make a read only virtual var on the cryptograph
			Events.emit_letter_scored(cryptograph.resource.letter.character)
	evaluating_score *= score_object.length_mult
	for multiplier in score_object.additional_mults:
		evaluating_score *= score_object.additional_mults[multiplier]
	current_score += evaluating_score
	evaluating_score = 0.0
	is_evaluating = false


func _on_subprocess_addition(adder : int) -> void:
	if !is_evaluating:
		DebugNode.print("WARNING: Subprocess Addition triggered outside of scoring")
	else:
		evaluating_score += adder

func _on_subprocess_multiplication(multiplier : float) -> void:
	if !is_evaluating:
		DebugNode.print("WARNING: Subprocess Multiplication triggered outside of scoring")
	else:
		evaluating_score *= multiplier
			

## Custom class representing the scoring information for a word. This class is generally used exclusively within this scoring module, to update the `score_object` variable.
class ScoringObject:
	## Dictionary of prefix names based on word length.
	const PREFIX_MAP = {
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
	## Dictionary of letters to their equivalent letters when rotated 180 degrees. If a letter cannot be rotated and still read, it is not inside this dictionary.
	const GYRO_MAP = {
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
	## Boolean representing inputted word validity accordng to in-game dictionary.
	var valid : bool
	## Multiplier based on length of inputted word.
	var length_mult : float
	## Name describing inputted word, based on word length.
	var word_name : String
	## The word being assessed for valid multipliers.
	var word : String
	## Other multipliers based on special criteria.
	var additional_mults : Dictionary[StringName, float] = {}
	## Utility Callable to convert the entity to a Dictionary for printing purposes.
	var to_dictionary : Callable = DebugNode.make_to_printable_method(self, [
			"valid",
			"base_score",
			"length_mult",
			"word_name",
			"additional_mults",
			"total_score"
	])

	func _init(input_word : String, hand : Hand):
		word = input_word
		valid = is_valid(word)
		if !valid:
			return
		var letters = hand.letters
		length_mult = get_length_mult(word)
		word_name = get_word_name(word)

		if is_palindrogram(word):
			additional_mults.palindrogram = Player.palindrogram_mult
		elif is_semordnigram(word):
			additional_mults.semordnigram = Player.semordnigram_mult
		
		if is_equigram(word):
			additional_mults.equigram = Player.equigram_mult
		
		if is_pangram(word, letters):
			if is_perfectigram(word):
				additional_mults.perfectigram = Player.perfectigram_mult
			else:
				additional_mults.pangram = Player.pangram_mult
		elif is_isogram(word):
			additional_mults.isogram = Player.isogram_mult
		
		if is_anagram(word):
			additional_mults.anagram = Player.anagram_mult
		
		if is_redupligram(word):
			additional_mults.redupligram = Player.redupligram_mult
		
		var flipped = flip_word(word)
		if flipped:
			if flipped == word:
				additional_mults.gyrogram = Player.gyrogram_mult
			elif is_valid(flipped):
				additional_mults.ambigram = Player.ambigram_mult


	## Creates the word name.
	static func get_word_name(input_word : String):
		var length = input_word.length()
		if length < Player.MINIMUM_WORD_LENGTH:
			return
		if length < 21:
			var prefix = PREFIX_MAP[length]
			return prefix + 'gram'
		return 'ICOSA++++'


	## Rotates a word 180 degrees for checking ambigrams and gyrograms
	static func flip_word(input_word : String) -> Variant:
		var flipped = input_word.reverse()
		for i in range(flipped.length()):
			if !GYRO_MAP.has(flipped[i]):
				return false
			flipped[i] = GYRO_MAP[flipped[i]]
		return flipped


	## Checks a word's validity.
	static func is_valid(input_word : String) -> bool:
		if input_word.length() < Player.MINIMUM_WORD_LENGTH:
			return false
		if DebugNode.accept_all_words:
			return true
		var first_letter = input_word[0]
		var words = FileAccess.open('res://words/' + first_letter + '.txt', FileAccess.READ).get_as_text().split('\n')
		return words.has(input_word)

	
	## Checks for a palindrome by reversing the word and comparing it to the original word.
	static func is_palindrogram(input_word : String) -> bool:
		# Word is the same forward and backward
		return input_word.reverse() == input_word


	## Checks for a semordnilap by reversing the word.
	static func is_semordnigram(input_word : String) -> bool:
		# Word is still valid when reversed
		return is_valid(input_word.reverse())


	## Checks for an equigram by comparing the word's vowel count to consonant count.
	static func is_equigram(input_word : String) -> bool:
		var vowels = 0
		var cons = 0
		for letter in input_word:
			# NOTE: use contants vowels
			if ['A', 'E', 'I', 'O', 'U'].has(letter):
				vowels += 1
			else:
				cons += 1
		return vowels == cons


	## Checks for a pangram by first checking the word's length, then checking if all cryptographs are represented within it.
	static func is_pangram(input_word : String, letters : Array) -> bool:
		if input_word.length() < Player.HAND_SIZE:
			return false
		for character in letters:
			if !input_word.contains(character):
				return false
		return true


	## Checks for a perfect pangram by confirming that the length of the word is the player's hand size (assumes word has already passed pangram check).
	static func is_perfectigram(input_word : String) -> bool:
		# NOTE: logic here might be too simplistic. Just scored a perfectigram with "DROLLY" because by current hand was D L R O Y L.
		return input_word.length() == Player.HAND_SIZE


	## Checks if the word uses each of its letters exactly once.
	static func is_isogram(input_word : String) -> bool:
		var map = []
		for letter in input_word:
			if map.has(letter):
				return false
			else:
				map.append(letter)
		return true


	## Checks if the word is an anagram of a previously played word.
	static func is_anagram(input_word : String) -> bool:
		var alpha = input_word.split()
		alpha.sort()
		alpha = "".join(alpha)
		
		if Player.anagrams.has(alpha):
			return true
		else:
			return false


	## Checks if the word consists of two or three repeated sections, e.g. CANCAN, TUTU.
	static func is_redupligram(input_word : String) -> bool:
		@warning_ignore_start("integer_division")
		var length = input_word.length()
		if length % 2 == 0:
			var one = input_word.left(-1 * (length / 2))
			var two = input_word.right(-1 * (length / 2))
			if one == two:
				return true
		if length % 3 == 0:
			var one = input_word.left(-1 * (length / 3 * 2))
			var two = input_word.left(-1 * (length / 3)).right(-1 * (length / 3))
			var three = input_word.right(-1 * (length / 3 * 2))
			if one == two and two == three:
				return true
		@warning_ignore_restore("integer_division")
		return false


	## Calculates length multiplier based on word length.
	static func get_length_mult(input_word : String) -> float:
		return 1 + Player.LENGTH_MULTIPLIER * input_word.length()
