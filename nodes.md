<div align="center" />

<img align="right" src="./readme_logo.png" width="300"/>

<div align="left" />

# GML Behavior Tree

The classic Behavior Tree to GMS 2.3+

## How our nodes works


### Composites

A composite is a node that can have more than one child. They will process one or more of them children.

| Name             | Description                        |
|------------------|------------------------------------|
| Sequence         | Process each child and when that return Success Process the next one|
| Selector         | Process each child, but only process the next if this actual returns Failure|


### Decorators

A decorator is a node that can have only one child. They will process this child and transform the received status

| Name             | Description                        |
|------------------|------------------------------------|
| Succeeder        | Process the child and always return Success|
| Inverter         | Process the child and invert the received Status|

### Leafs

A leaf node is a node that will process the behavior. This need to return one of the BTStates enum.

You can see details about how to create behaviors in [example.md](./example.md)

### Root

The Root node is a custom node that will start our tree. Is responsible by startup the tree, init our Blackboard and some other configs.

## References

- https://www.gamasutra.com/blogs/ChrisSimpson/20140717/221339/Behavior_trees_for_AI_How_they_work.php
