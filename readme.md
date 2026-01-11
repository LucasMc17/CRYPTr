# FORMATTING GUIDE

1.  @tool, @icon, @static_unload
2.  class_name
3.  extends
4.  ## doc comment

5.  signals
6.  enums
7.  constants
8.  static variables
9.  @export variables
10. remaining regular variables
11. @onready variables

12. \_static_init()
13. remaining static methods
14. overridden built-in virtual methods:
	1.  \_init()
	2.  \_enter_tree()
	3.  \_ready()
	4.  \_process()
	5.  \_physics_process()
	6.  remaining virtual methods
15. overridden custom methods
16. remaining methods
17. subclasses

# Z INDEX CONSTANTS

Gameplay Layer - 0

Menu Layer - 10

Debug Layer - 20

# IDEAS

Maybe instead of something akin to balatro's jokers, we split the functionality out into two items, one focused on effects and one focused on triggers. So you could combine the "ON ROUND STARTED" trigger with the "INCREASE WORD TYPE VALUE" effect. You would only be able to change your configrations outside of an active encounter (so in the map screen essentially) and you would have a cap on the number of triggers and effects you could carry. There would also be a memory limit and a memory cost associated with each effect and trigger. For example, the memory cost of the "ON ROUND STARTED" trigger would be lower than the "ON WORD ENTERED" trigger. So you would have to be strategic with what effects you have active. You could also upgrade memory like other stats.
