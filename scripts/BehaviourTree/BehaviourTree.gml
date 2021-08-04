function BTreeNode() constructor{
    status = "running";
    children = [];
    visited = false;
    vars = {inst: noone};
    
    static Init = function(){
    }
    
    static Process = function(){
        return "success";
    }
    
    static ChildAdd = function(_child){
        array_push(children, _child);
    }
	
	static NodeProcess = function(_node){
		_node.vars = vars;
		var _status= _node.Process();
		vars = _node.vars
		
		return _status
	}

}

function BTreeComposite() : BTreeNode() constructor{
    
}

function BTreeLeaf() : BTreeNode() constructor{
    
}

function BTreeRoot(_inst): BTreeNode() constructor{
	status = "not started";
	array_push(children, noone);
	vars.inst = _inst;
	vars.running_node = noone
	
	static Start = function(){
		status = "running";
	}
	
	static Process = function(){
		
		if(vars.running_node != noone){ //run the actual running node if exists
			NodeProcess(vars.running_node)
		}
		
		else if(children[0] != noone){ //run the entire tree
            if(status == "running"){
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

function BTreeSequence() : BTreeComposite() constructor
{
    static Process = function(){
        for(var i = 0; i < array_length(children); i++){
            var _child = children[i];
            if(_child.status == "running"){
                if(_child.visited == false){
                    _child.Init();
                    _child.visited = true;
                }
                
                var _status = NodeProcess(_child)
                
                if(_status == "running"){
                    return "running";
                }
                else if(_status == "failure"){
                    return "failure";
                }
            }
        }
        return "success";
    }
}