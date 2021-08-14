/// ||||  |||||  |   |  |||||  |   |  |  ||||| |   |  |||||   ||||| ||||| ||||| |||||  
/// |  |  |      |   |  |   |  |   |  |  |   | |   |  |   |     |   |   | |     |       
/// |||   |||||  |||||  |||||  |   |  |  |   | |   |  ||||      |   ||||  ||||| |||||   
/// |  |  |      |   |  |   |   | |   |  |   | |   |  |  |      |   |  |  |     |       
/// ||||  |||||  |   |  |   |    |    |  ||||| |||||  |   |     |   |   | ||||| |||||

/// Attempt to create a Behaviour Tree in GML for GAME MAKER STUDIO 2.3+
/// Mantained by @vitorstvm and @jalesjefferson
/// Big Thanks to https://github.com/squircledev for helping us with 
/// the first steps of this project

#region Code Log + Script General notes
#region @jalesjefferson code revision - 08/08/2021
/* Criei uma branch nova, tanto para deixar os comentários como revisar o código ver se precisa de alguma modificação
   A gente bem q poderia deixar o padrão de 2 tabs em kkk. Mas como ta 4 to usando o gm_edit pra facilitar,
   já que é só código pesado mesmo.
   Vou ver se consigo fazer tbm um modelo pra debug visual, mas tem que ver bem a escalabilidade disso, pq temo 
   virar uma parada complexa demais, mas bora ver como fica! 
*/
#endregion 
#endregion

/// ============================================================================
/// DEBUG MACROS
#macro BT_DEBUG_ON                  true        //   
#macro BT_DEBUG_NODE_COLOR          c_white     //
#macro BT_DEBUG_NODE_RUNNING_COLOR  c_yellow    //

/// ============================================================================

/// Behaviour Tree BT possible STATES and Return values 
enum BTStates
{
	Running,    // If the node is current running
	Success,    // If the node is already have succeeded it task
	Failure,    // In Case the node failed to do it task
	Off,        // In Case the node is turned off, it will do nothing
}

/// This is the BASIC Behavior Tree node. 
function BTreeNode() constructor{
    name = "BT_TREE_NODE_BASE";     // The node name, for debug purposes
    status = BTStates.Running;      // The Current Status of the node    
    visited = false;                // If it already been visited or not Flow Control
    
    children = [];                  // The node children. Array cause it faster and we don't have to clean it later 
    children_arr_len = 0;           // The actual chidren array lenght, that way, we don't have to check every step the length of the children, making this a little more faster 
    
    black_board_ref = noone;        // The reference to blackboard struct. This will be set on BTreeRoot.
    
    /// When visiting the node for the first time, 
    /// you can call this for some extra configs
    static Init = function(){}
    
    /// Called in every step of the game. 
    /// Always have to return something and have to be the one of the BTStates enum
    static Process = function(){    
        return BTStates.Success;
    }
    
    /// Adding new childrens to this node.
    static ChildAdd = function(_child){
        array_push(children, _child);
        ++children_arr_len;
    }
	
    /// Here's the good stuff. / @jalesjefferson -> Now only the reference will be parsed when visited
    /// We have to make sure the root have the reference to the running node
    /// This way, we can jump to this node to continue it task.
    /// This function is called by the current node scope. 
	static NodeProcess = function(_node){
		
		/// Case it's first time we visiting this node. 
		/// Parse the blackboard reference
		/// Set the visited flag on, them init Node. 
		if(_node.visited == false){
            _node.black_board_ref = black_board_ref; 
            _node.visited = true;
            _node.Init();
        }
		
		/// Process node logic -> Expects to return a BTState
		var _status = _node.Process();
		
		// Stores current node
		/// First Case -> This node is now running and the black_board don't have any reference of the running node 
		/// Second Case -> The current node is not running anymore and we have a running node -> Not anymore! Let's check you tree again
		if(_status == BTStates.Running and black_board_ref.running_node == noone) 
		    black_board_ref.running_node = _node
		else if( _status != BTStates.Running and black_board_ref.running_node != noone) 
		    black_board_ref.running_node = noone
		
		/// Return the BTState	
		return _status
	}

}

/// Everything starts here. To use the composites and the task, you have to setup a 
/// Behaviour Tree Root. Create a new bt_root on a Create Event of an instance. 
/// Call bt_root.Init() to turn on your bt_root and put the bt_root.Process() on your
/// Step Event to use your BT.
/// @param The BTreeRoot expects an instance id.
function BTreeRoot(_inst): BTreeNode() constructor{
	name = "BT_ROOT";
	status = BTStates.Off;          // Starts off, in that case, will only work if Init    
	array_push(children, noone);    // The BTRoot can only have one child  
	
	// All exclusive variables of the node will be placed here, kinda Blackboard
	// This info will be parced from node to node, making possible to make a more faster
	// You can put more stuff here. All Nodes will have acess to this variables. 
    black_board = {                  
        root_reference : other,     // The Root Ref.
        inst_ref : _inst,           // The Instance id that will be used on this BT.         
        running_node: noone,        // The running node reference
    };
    
    black_board_ref = black_board; // The blackboard ref to parse to everyone else on NodeProcess
    
	/// @override / @jalesJefferson -> Changed from Start() to Init(), to use the inherent stuff
	static Init = function(){
		status = BTStates.Running;
	}
	
	/// @override Called on every frame by a step event
	static Process = function(){
        /// Run the actual running node, if it exists
		if(black_board.running_node != noone)
			NodeProcess(black_board.running_node);
		
        /// Run the entire tree | @jalesjefferson moved the visited check to NodeProcess 
		else if(children[0] != noone){
		    if(status == BTStates.Running)
		       NodeProcess(children[0]);
        }
    }

	/// @override the ChildAdd from BTreeNode, cause the root can only have one child
	/// @param child_node expects at least a BTreeNode.
	static ChildAdd = function(child_node){
		children[0] = child_node;
		children_arr_len = 1;
  }
}

/// BTreeSequence Composite! 
/// 
function BTreeSequence() : BTreeComposite() constructor{
	name = "BT_SEQUENCE";
        
    /// @override 
    /// @jalesjefferson make some big changes here to make some minor improvements 
    /// 1. If to Switch statements; 
    /// 2. Create the children_arr_len to make it a little
    /// 3. FOR to REPEAT loops.
    /// 4. Don't creating a new local var on every loop
    
    static Process = function(){
        var _i = 0; 
        repeat(children_arr_len){
            if(children[_i].status == BTStates.Running){
                switch( NodeProcess(children[_i])){
                    case BTStates.Running: return BTStates.Running;
                    case BTStates.Failure: return BTStates.Failure; 
                }
            }
            
            ++_i;
        }
        
        return BTStates.Success;
    }
}

function BTreeSelector() : BTreeComposite() constructor{
	name = "BT_SELECTOR";
    
    static Process = function(){
        var _i = 0;
        repeat(children_arr_len){
            if(children[_i].status == BTStates.Running){
                switch(NodeProcess(children[_i])){
                    case BTStates.Running: return BTStates.Running;
                    case BTStates.Success: return BTStates.Success;
                }
            }

            ++_i;
        }
        
        return BTStates.Failure;
    }     
}

///
function BTreeInverter() : BTreeDecorator() constructor{
	name = "BT_Inverter";
	
	static Process = function(){
		var _state = NodeProcess(children[0]);
		switch(_state){
			case BTStates.Failure: return BTStates.Success;
			case BTStates.Success: return BTStates.Failure;
			default: return _state;
		}
	}
}

/// Decorators can only have one child
function BTreeDecorator() : BTreeNode() constructor{
	static ChildAdd = function(child_node){
		children[0] = child_node;
		children_arr_len = 1;
  }
}

function BTreeComposite() : BTreeNode() constructor{}
function BTreeLeaf() : BTreeNode() constructor{}
