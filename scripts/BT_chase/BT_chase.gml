function BehaviorFind(_inst) : BTreeLeaf() constructor{	
	name = "Find Nearest Instance";
	inst_to_find = _inst

    static Process = function()
    {	
		show_debug_message("on Bfind Process");
		var _inst = instance_nearest(black_board_ref.inst_ref.x, black_board_ref.inst_ref.y, inst_to_find);
		if(_inst == noone) return BTStates.Failure
		else{
			black_board_ref.inst_to_chase = _inst
			return BTStates.Success;
		}
    }
}

function BehaviorChase() : BTreeLeaf() constructor{  
    name = "Chase Instance";
    chase_distance = 64
    static Process = function(){
		show_debug_message("on Bchase Process");
		var goto = black_board_ref.inst_to_chase;
		var dis = point_distance(black_board_ref.inst_ref.x,black_board_ref.inst_ref.y,goto.x,goto.y)
		
		if(dis < chase_distance){
			black_board_ref.inst_ref.speed = 0
			return BTStates.Success;
		}
		
		else{
			black_board_ref.inst_ref.image_blend = c_white
			with(black_board_ref.inst_ref) move_towards_point(goto.x,goto.y,2)
			return BTStates.Running
		}

    }
}

function BehaviorReach() : BTreeLeaf() constructor{  
    name = "On Reach";
    
    static Process = function(){
		show_debug_message("on Breach Process");
		black_board_ref.inst_ref.image_blend = c_red
        return BTStates.Success;
    }
}

///
function find_and_chase_bt(){
	var _sequence = new BTreeSequence()
	with(_sequence){
		ChildAdd(new BehaviorFind(o_mouse_follower));
	    ChildAdd(new BehaviorChase());
		ChildAdd(new BehaviorReach());
	}
	
	return _sequence
}