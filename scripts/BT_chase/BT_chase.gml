function BehaviorFind(_inst) : BTreeLeaf() constructor
{	
	inst_to_find = _inst

    static Process = function()
    {	
		show_debug_message("on Bfind Process");
		var _inst = instance_nearest(vars.inst.x, vars.inst.y, inst_to_find);
		if(_inst == noone) return BTStates.Failure
		else{
			vars.inst_to_chase = _inst
			return BTStates.Success;
		}
    }
}

function BehaviorChase() : BTreeLeaf() constructor{  
    static Process = function(){
		show_debug_message("on Bchase Process");
		var goto = vars.inst_to_chase
		var dis = point_distance(vars.inst.x,vars.inst.y,goto.x,goto.y)
		
		if(dis<64){
			vars.inst.speed = 0
			return BTStates.Success;
		}
		
		else{
			vars.inst.image_blend = c_white
			with(vars.inst) move_towards_point(goto.x,goto.y,2)
			return BTStates.Running
		}

    }
}

function BehaviorReach() : BTreeLeaf() constructor{  
    static Process = function(){
		show_debug_message("on Breach Process");
		vars.inst.image_blend = c_red
        return BTStates.Success;
    }
}


function find_and_chase_bt(){
	var _sequence = new  BTreeSequence()
	with(_sequence){
		ChildAdd(new BehaviorFind(Object3));
	    ChildAdd(new BehaviorChase());
		ChildAdd(new BehaviorReach());
	}
	
	return _sequence
}