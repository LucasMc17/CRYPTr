@tool
class_name StarterStack
extends Resource
## Custom resource representing a starter stack at the beginning of a run.
##
## Represents it's count of each type of cryptograph as a number rather than including a single long array of all cryptographs.
## e.g. `{ "A": 3, "B": 2 }` as opposed to `["A", "A", "A", "B", "B"]`.

## Read-only variable for displaying the total count of cryptographs in the starter stack in the editor.
## Best practice is to keep total count under 55-60.
@export var total : int:
	get():
		return a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q + r + s + t + u + v + w + x + y + z # + wildcard
	set(val):
		return

# Vowels, all worth 1 point
@export_group("Vowels")

## Count of A Cryptographs worth 1 point
@export var a := 0

## Count of E Cryptographs worth 1 point
@export var e := 0

## Count of I Cryptographs worth 1 point
@export var i := 0

## Count of O Cryptographs worth 1 point
@export var o := 0

## Count of U Cryptographs worth 1 point
@export var u := 0

# Easy consonants, worth 1-2 points
@export_group("Easy Letters")

## Count of L Cryptographs worth 1 point
@export var l := 0

## Count of N Cryptographs worth 1 point
@export var n := 0

## Count of R Cryptographs worth 1 point
@export var r := 0

## Count of T Cryptographs worth 1 point
@export var t := 0

## Count of D Cryptographs worth 2 points
@export var d := 0

## Count of G Cryptographs worth 2 points
@export var g := 0

# Medium consonants, worth 3-5 points
@export_group("Medium Letters")

## Count of B Cryptographs worth 3 points
@export var b := 0

## Count of C Cryptographs worth 3 points
@export var c := 0

## Count of M Cryptographs worth 3 points
@export var m := 0

## Count of P Cryptographs worth 3 points
@export var p := 0

## Count of F Cryptographs worth 4 points
@export var f := 0

## Count of H Cryptographs worth 4 points
@export var h := 0

## Count of V Cryptographs worth 4 points
@export var v := 0

## Count of W Cryptographs worth 4 points
@export var w := 0

## Count of Y Cryptographs worth 4 points
@export var y := 0

## Count of K Cryptographs worth 5 points
@export var k := 0

# Hard consonants, worth 8-10 points
@export_group("Hard Letters")

## Count of J Cryptographs worth 8 points
@export var j := 0

## Count of X Cryptographs worth 8 points
@export var x := 0

## Count of Q Cryptographs worth 10 points
@export var q := 0

## Count of Z Cryptographs worth 10 points
@export var z := 0

@export_group("Special Letters")

## Count of S Cryptographs worth 1 point
@export var s := 0

## Count of Wildcard Cryptographs, worth variable points
# @export var wildcard := 0

# CLASSIC

# A = 5
# E = 5
# I = 5
# O = 5
# U = 5

# L = 4
# N = 4
# R = 4
# T = 4
# D = 4
# G = 4

# B = 1
# C = 1
# M = 1
# P = 1
# F = 1
# H = 1
# V = 1
# W = 1
# Y = 1
# K = 1

# J = 1
# X = 1
# Q = 1
# Z = 1

# S = 0
# WILD = 0