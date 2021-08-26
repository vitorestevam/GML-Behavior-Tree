<div align="center" />

<img align="right" src="./readme_logo.png" width="300"/>

<div align="left" />

# GML Behavior Tree

The classic Behavior Tree to GMS 2.3+

> if you don't know what you're doing here or need to learn what is a Behavior Tree, you can see it on our [references](#references)

## How to use
``` gml
//create
function TaskChangeColor() : BTreeLeaf() constructor{
	name = "TaskChangeColor";
	
	/// @override
	static Process = function(){
		black_board_ref.user.image_blend = c_yellow
		return BTStates.Success;
	}
}

bt_root = new BTreeRoot(id);
var change_color = new TaskChangeColor()
bt_root.ChildAdd(change_color)

bt_root.Init();

//step
bt_root.Process();
```

See details on [example.md](./example.md)

## [Nodes docs](./nodes.md)

## [How its builded](./builded.md)

## Contributors

<a href="https://github.com/VitorEstevam/Behaviour-Tree-Friends/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=VitorEstevam/Behaviour-Tree-Friends" />
</a>

## References

- https://en.wikipedia.org/wiki/Behavior_tree_(artificial_intelligence,_robotics_and_control)
- https://www.gamasutra.com/blogs/ChrisSimpson/20140717/221339/Behavior_trees_for_AI_How_they_work.php

And a especial thank you to [squircledev](https://github.com/squircledev) how shared some drafts with us :)
