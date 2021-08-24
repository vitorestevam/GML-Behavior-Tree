/// @desc bt Start
bt_root = new BTreeRoot(id);

// --- 
var _selector_root = new BTreeSelector();
var _sequence_chase = new BTreeSequence();
var _chase_in_range = new TaskInstanceInRange(o_mouse_follower, 200);
var _chase_behave = new TaskChaseInstance(o_mouse_follower, 2.5, 400, 64);
var _succeder = new BTreeSucceeder();
var _hit = new TaskMeleeHitTarget(o_mouse_follower, 1.5);
var _patrol = new TaskPatrolSimple(1, 2);

bt_root.ChildAdd(_selector_root);

_sequence_chase.ChildAdd(_chase_in_range);
_sequence_chase.ChildAdd(_chase_behave);
_sequence_chase.ChildAdd(_succeder);
_succeder.ChildAdd(_hit);

_selector_root.ChildAdd(_sequence_chase);
_selector_root.ChildAdd(_patrol);


bt_root.Init();
