class_name FiniteStateMachine extends Node

var states: Dictionary = {}
var current_state: State
@export var initial_state: State


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.update(delta)
	


#func force_change_state(new_state_name: String):
	#var new_state = states.get(new_state_name.to_lower())
	#
	#if not new_state:
		#print(new_state + " does not exist in the dictionary of states")
		#return
#
	#if current_state == new_state:
		#print("State is same, aborting")
		#return
#
	#if current_state:
		#var exit_callable = Callable(current_state, "exit")
		#exit_callable.call_deferred()
	#new_state.enter()


func change_state(source_state: State, new_state_name: String):
	if source_state != current_state:
		#print("Invalid change_state trying form: " +\
		 #	  source_state.name + " but currently in: " + current_state.name)
		return

	var new_state: State = states.get(new_state_name.to_lower())
	if not new_state:
		print("New state is empty")
		return

	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
