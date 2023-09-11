extends Node

var runtime := 0.0
var speed := 2.0

var results_data = {
	"score": 0,
	"total_bills_collected": 0,
	"lefty_attacks": 0,
	"lefties_purchased": 0,
	"cars_destroyed": 0,
	"transmission_fluid_collected": 0,
	"root_hit": false
}

func cartesian_to_isometric(cartesian: Vector2) -> Vector2:
	
	return Vector2(cartesian.x - cartesian.y, cartesian.x + cartesian.y) / sqrt(3) # THIS IS WRONG AND I"M GONNA KILL EVERYONE
		
	# inclinations
	#var LI := 14
	#var CI :=
	#var RI := 45
	# scales
	#var LS := 0.922057
	#var CS := 0.866413
	#var RS := 0.631775
	# scale ratios
	#var LR := 
	#var CR := 
	#var RR := 
	# ellipse projection angles
	#var LE := 50.818815
	#var CE := 29.955521
	#var RE := 22.771361
	
	#var m = Transform2D(LS,RS,CS)
	
	#return Vector2((cartesian.x - cartesian.y) * (1 + LS), (cartesian.x + cartesian.y) * (1 + RS)) / 1 + CS# / sqrt(3)
	
	#return Vector2(cartesian.x - cartesian.y, cartesian.x + cartesian.y)# / Vector3(LS, CS, RS)
