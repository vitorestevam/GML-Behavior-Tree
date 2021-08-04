enum BTStates{
	Running,
	Success,
	Failure,
	Off,
}

function BTreeNode() constructor{
    status = BTStates.Running;
    children = [];
    visited = false;
    vars = {inst: noone, running_node: noone};
    
    static Init = function(){
    }
    
    static Process = function(){
        return BTStates.Success;
    }
    
    static ChildAdd = function(_child){
        array_push(children, _child);
    }
	
			
	static NodeProcess = function(_node){
		_node.vars = vars;
		var _status= _node.Process();
		vars = _node.vars	
		
		//stores current node
		if(_status == BTStates.Running and vars.running_node == noone) vars.running_node = _node
		else if( _status != BTStates.Running and vars.running_node != noone) vars.running_node = noone

			
		return _status
	}

}

function BTreeComposite() : BTreeNode() constructor{
    
}

function BTreeLeaf() : BTreeNode() constructor{
    
}

function BTreeRoot(_inst): BTreeNode() constructor{
	status = BTStates.Off;
	array_push(children, noone);
	vars.inst = _inst;
	
	static Start = function(){
		status = BTStates.Running;
	}
	
	static Process = function(){
		
		if(vars.running_node != noone){ //run the actual running node if exists
			NodeProcess(vars.running_node)
		}
		
		else if(children[0] != noone){ //run the entire tree
            if(status == BTStates.Running){
                if(children[0].visited == false){
                    children[0].Init();
                    children[0].visited = true;
                }
				NodeProcess(children[0]);
            }
        }
    }
	
	static ChildAdd = function(_child){
		children[0] = _child;
    }
}

function BTreeSequence() : BTreeComposite() constructor{
    static Process = function(){
        for(var i = 0; i < array_length(children); i++){
            var _child = children[i];
            if(_child.status == BTStates.Running){
                if(_child.visited == false){
                    _child.Init();
                    _child.visited = true;
                }
                
                var _status = NodeProcess(_child)
                
                if(_status == BTStates.Running){
                    return BTStates.Running;
                }
                else if(_status == BTStates.Failure){
                    return BTStates.Failure;
                }
            }
        }
        return BTStates.Success;
    }
}