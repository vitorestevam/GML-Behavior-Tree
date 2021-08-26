/* 
	The classic Behavior Tree to GMS 2.3+
	if you don't know what you're doing here or need to learn what is a Behavior Tree, 
	you can see it on our references

	https://github.com/VitorEstevam/GML-Behaviour-Tree
	Mantained by @vitorstvm and @jalesjefferson
*/

enum BTStates
{
	Running,   
	Success,   
	Failure,   
	Off,       
}

///@abstract
function BTreeNode() constructor{
    name = "BT_TREE_NODE_BASE";     
    status = BTStates.Running;      
    visited = false;                
		
    children = [];                  
    children_arr_len = 0;           
    black_board_ref = noone;        
    
    static Init = function(){}
    
    static Process = function(){    
        return BTStates.Success;
    }
    
    static ChildAdd = function(_child){
        array_push(children, _child);
        ++children_arr_len;
    }
	
		static NodeProcess = function(_node){
		
			if(_node.visited == false){ // Initial configure
        _node.black_board_ref = black_board_ref; 
        _node.visited = true;
        _node.Init();
      }
		
		var _status = _node.Process(); // Returning State
		
		if(_status == BTStates.Running and black_board_ref.running_node == noone){
		  black_board_ref.running_node = _node
		}
		else if( _status != BTStates.Running and black_board_ref.running_node != noone){
			black_board_ref.running_node = noone;
		}
		
		return _status
	}

}

///@abstract
function BTreeComposite() : BTreeNode() constructor{}

///@abstract
function BTreeLeaf() : BTreeNode() constructor{}

///@abstract
function BTreeDecorator() : BTreeNode() constructor{
	/// @overwrite
	static ChildAdd = function(child_node){
		children[0] = child_node;
		children_arr_len = 1;
  }
}

/// @param inst_id - Expects an instance id.
function BTreeRoot(inst_id): BTreeNode() constructor{
	name = "BT_ROOT";
	status = BTStates.Off;          
	array_push(children, noone);    
	
  black_board = {  
		  user : inst_id,           
      root_reference : other,     
      running_node: noone,        
  };
    
  black_board_ref = black_board; 
    
	/// @override 
	static Init = function(){
		status = BTStates.Running;
	}
	
	/// @override 
	static Process = function(){
		if(black_board.running_node != noone)
			NodeProcess(black_board.running_node);
		
		else if(children[0] != noone){
		    if(status == BTStates.Running)
		       NodeProcess(children[0]);
        }
    }

	/// @override 
	/// @param child_node - Expects a BTreeNode.
	static ChildAdd = function(child_node){
		children[0] = child_node;
		children_arr_len = 1;
  }
}

function BTreeSequence() : BTreeComposite() constructor{
	name = "BT_SEQUENCE";
        
    /// @override 
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
    
		/// @override
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

function BTreeInverter() : BTreeDecorator() constructor{
	name = "BT_Inverter";
	
	/// @override
	static Process = function(){
		var _state = NodeProcess(children[0]);
		switch(_state){
			case BTStates.Failure: return BTStates.Success;
			case BTStates.Success: return BTStates.Failure;
			default: return _state;
		}
	}
}

function BTreeSucceeder() : BTreeDecorator() constructor{
	name = "BT_Succeeder";
	
	/// @override
	static Process = function(){
		var _state = NodeProcess(children[0]);
		return BTStates.Success;
	}
}




