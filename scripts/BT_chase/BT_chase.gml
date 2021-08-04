function BehaviorFind(_inst) : BTreeLeaf() constructor
{	
	inst_to_find = _inst

    static Process = function()
    {	
		var _inst = instance_nearest(vars.inst.x, vars.inst.y, inst_to_find);
		if(_inst == noone) return "failure"
		else{
			vars.inst_to_chase = _inst
			return "success";
		}
    }
}

function BehaviorChase() : BTreeLeaf() constructor{  
    static Process = function(){
		var goto = vars.inst_to_chase
		var dis = point_distance(vars.inst.x,vars.inst.y,goto.x,goto.y)
		
		if(dis<64){
			vars.inst.speed = 0
			return "success";
		}
		
		else{
			with(vars.inst) move_towards_point(goto.x,goto.y,2)
			return "running"
		}

    }
}

function BehaviorReach() : BTreeLeaf() constructor{  
    static Process = function(){
		show_debug_message("on Breach Process");
		vars.inst.image_blend = c_red
		
        return "success";
    }
}

function BehaviorFindAndChase() : BTreeSequence() constructor{
    ChildAdd(new BehaviorFind(Object3));
    ChildAdd(new BehaviorChase());
	ChildAdd(new BehaviorReach());
}