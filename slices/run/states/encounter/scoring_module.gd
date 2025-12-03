class_name ScoringModule
extends Node
## Logic module for determining validity of word and scoring it if valid.
##
## Also manages current and target scores, and compares them to check for a win.

## Player's current score in the active encounter.
var current_score := 0.0
## Current encounter's target score for comparison with player's score.
var target_score := 0.0
## ScoringObject represenging the multipliers and total score of the current word before entry.
var score_object : ScoringObject

## Updates the score_object with a new object based on word and hand.
func update_score_object(word : String, hand : Hand) -> void:
	score_object = ScoringObject.new(word, hand)


## Compares target score and current score to determine if the player has won.
func check_win() -> bool: 
	return current_score >= target_score

# NOTE: Review this later. Does this really have to be a class?
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
	## Score before multipliers, calculated from word and point values of relevant cryptographs in hand.
	var base_score : float
	## Multiplier based on length of inputted word.
	var length_mult : float
	## Name describing inputted word, based on word length.
	var word_name : String
	## Other multipliers based on special criteria.
	var additional_mults : Dictionary[String, float] = {}
	## Final score after all multipliers are applied.
	var total_score : float

	func _init(word : String, hand : Hand):
		valid = is_valid(word)
		if !valid:
			return
		var cryptographs = hand.cryptographs
		var letters = hand.letters
		base_score = get_base_score(word, cryptographs)
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

		total_score = base_score * length_mult
		for mult in additional_mults:
			total_score *= additional_mults[mult]


	## Creates the word name.
	static func get_word_name(word : String):
		var length = word.length()
		if length < Player.MINIMUM_WORD_LENGTH:
			return
		if length < 21:
			var prefix = PREFIX_MAP[length]
			return prefix + 'gram'
		return 'ICOSA++++'


	## Rotates a word 180 degrees for checking ambigrams and gyrograms
	static func flip_word(word : String) -> Variant:
		var flipped = word.reverse()
		for i in range(flipped.length()):
			if !GYRO_MAP.has(flipped[i]):
				return false
			flipped[i] = GYRO_MAP[flipped[i]]
		return flipped


	## Checks a word's validity.
	static func is_valid(word : String) -> bool:
		# Word is in dictionary
		if word.length() < Player.MINIMUM_WORD_LENGTH:
			return false
		if DebugNode.accept_all_words:
			return true
		var first_letter = word[0]
		var words = FileAccess.open('res://words/' + first_letter + '.txt', FileAccess.READ).get_as_text().split('\n')
		return words.has(word)

	
	## Checks for a palindrome by reversing the word and comparing it to the original word.
	static func is_palindrogram(word : String) -> bool:
		# Word is the same forward and backward
		return word.reverse() == word


	## Checks for a semordnilap by reversing the word.
	static func is_semordnigram(word : String) -> bool:
		# Word is still valid when reversed
		return is_valid(word.reverse())


	## Checks for an equigram by comparing the word's vowel count to consonant count.
	static func is_equigram(word : String) -> bool:
		var vowels = 0
		var cons = 0
		for letter in word:
			if ['A', 'E', 'I', 'O', 'U'].has(letter):
				vowels += 1
			else:
				cons += 1
		return vowels == cons


	## Checks for a pangram by first checking the word's length, then checking if all cryptographs are represented within it.
	static func is_pangram(word : String, letters : Array) -> bool:
		if word.length() < Player.HAND_SIZE:
			return false
		for character in letters:
			if !word.contains(character):
				return false
		return true


	## Checks for a perfect pangram by confirming that the length of the word is the player's hand size (assumes word has already passed pangram check).
	static func is_perfectigram(word : String) -> bool:
		return word.length() == Player.HAND_SIZE


	## Checks if the word uses each of its letters exactly once.
	static func is_isogram(word : String) -> bool:
		var map = []
		for letter in word:
			if map.has(letter):
				return false
			else:
				map.append(letter)
		return true


	## Checks if the word is an anagram of a previously played word.
	static func is_anagram(word) -> bool:
		var alpha = word.split()
		alpha.sort()
		alpha = "".join(alpha)
		
		if Player.anagrams.has(alpha):
			return true
		else:
			return false


	## Checks if the word consists of two or three repeated sections, e.g. CANCAN, TUTU.
	static func is_redupligram(word : String) -> bool:
		@warning_ignore_start("integer_division")
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
		@warning_ignore_restore("integer_division")
		return false

	
	## Calculate the base score by adding the points of each applicable cryptograph from the hand, letter by letter.
	static func get_base_score(word : String, hand : Array[Cryptograph]) -> float:
		var score = 0.0
		for character in word:
			var applicable = hand.filter(func(cryptograph): return cryptograph.resource.letter.character == character)
			score += applicable.reduce(func(accum, cryptograph): return accum + cryptograph.resource.letter.points, 0.0)
		return score


	## Calculates length multiplier based on word length.
	static func get_length_mult(word : String) -> float:
		return 1 + Player.LENGTH_MULTIPLIER * word.length()


	## Utility function yadda yadda
	func to_object() -> Dictionary:
		return {
			"valid" : valid,
			"base_score": base_score,
			"length_mult": length_mult,
			"word_name": word_name,
			"additional_mults": additional_mults,
			"total_score": total_score
		}