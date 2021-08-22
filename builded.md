<div align="center" />

<img align="right" src="./readme_logo.png" width="300"/>

<div align="left" />

# GML Behavior Tree

The classic Behavior Tree to GMS 2.3+

## How its builded

Our implementation is builded all above the same BTreeNode struct:

### Variables:

| Name             | Description                        |
|------------------|------------------------------------|
| name             | The node name                      |
| status           | The Current Status of the node     |
| visited          | If it already been visited or not  |
| children         | The node children                  |
| children_arr_len | The actual children array length    |
| black_board_ref  | The reference to blackboard struct |

### Methods:

| Name                   | Description                                                                |
|------------------------|----------------------------------------------------------------------------|
| Init()                 | Call this for some extra configs when visiting the node for the first time |
| Process()              | Called in every step of the game. Need to return one of the BTStates enum  |
| ChildAdd(BTreeNode)    | Used to add a child to the node                                             |
| NodeProcess(BTreeNode) | Process other nodes                                                        |
