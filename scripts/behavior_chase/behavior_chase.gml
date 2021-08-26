
/// @param obj_ref
/// @param range 
function TaskInstanceInRange(obj, range) : BTreeLeaf() constructor {
	name = "Task Instance In Range";
	object_find = obj;
	range_limit = range;
	
	instance_ref = noone;

	/// @override
	static Init = function(){
		instance_ref = instance_find(object_find, 0);	
	}
	
	/// @override
	static Process = function(){
		if(instance_exists(instance_ref) && point_distance(black_board_ref.user.x, black_board_ref.user.y, instance_ref.x, instance_ref.y) <= range_limit)
			return BTStates.Success;
		else 
			return BTStates.Failure;
	}
}

/// @param speed
/// @param timer_secs
function TaskPatrolSimple(speed, timer_secs) : BTreeLeaf() constructor {
	name = "Taks Patrol Simple";
	patrol_speed = speed;
	
	patrol_spd_x = 0;
	patrol_spd_y = 0;
	
	patrol_direction = 0;
	patrol_timer_max = timer_secs * room_speed;
	patrol_timer = 0;
	
	/// @override
	static Process = function(){
		if(--patrol_timer <= 0){
			patrol_direction = irandom(360);
			patrol_spd_x = lengthdir_x(patrol_speed, patrol_direction);
			patrol_spd_y = lengthdir_y(patrol_speed, patrol_direction);
			patrol_timer = patrol_timer_max;
		}
		
		black_board_ref.user.x += patrol_spd_x;
		black_board_ref.user.y += patrol_spd_y;
		return BTStates.Success;
	}
}

/// @param instance_chase
/// @param speed_chase 
/// @param distance_max
/// @param distance_min
function TaskChaseInstance(instance_chase, speed_chase, distance_max, distance_min) : BTreeLeaf() constructor{
	name = "Task Chase Instance";
	
	chase_speed = speed_chase;
	instance_to_chase = instance_chase;
	distance_maximun_to_stop_chase = distance_max;
	distance_minimun_to_stop_chase = distance_min;
	
	///@override
	static Process = function(){
		if(instance_exists(instance_to_chase)){
			
			// Check Stop chasing
			var _dist = point_distance(black_board_ref.user.x, black_board_ref.user.y, instance_to_chase.x, instance_to_chase.y);
			if(_dist <= distance_minimun_to_stop_chase)
				return BTStates.Success;
			else if (_dist >= distance_maximun_to_stop_chase)
				return BTStates.Failure;
			else {
				// Moving towards chasing
				var _dir = point_direction(black_board_ref.user.x, black_board_ref.user.y, instance_to_chase.x, instance_to_chase.y);
				black_board_ref.user.x += lengthdir_x(chase_speed, _dir);
				black_board_ref.user.y += lengthdir_y(chase_speed, _dir);		
		
				return BTStates.Running;
			}
		}
		else 
			return BTStates.Failure

	}
	
}

/// @param instance_target
/// @param secs_between_hits 
function TaskMeleeHitTarget(instance_target, secs_preparation) : BTreeLeaf() constructor{
	name = "Task Melee Hit on Target";
	
	target_hit = instance_target;
	time_preparation_max = secs_preparation * room_speed;
	time_preparation = 0;
	
	/// @override
	static Process = function(){
		if(!instance_exists(target_hit)) return BTStates.Failure;
		if(++time_preparation >= time_preparation_max){
			time_preparation = 0;
			target_hit.life -= 10;
			return BTStates.Success;
		}
		else 
			return BTStates.Running;
	}
}
