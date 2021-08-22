<div align="center" />

<img align="right" src="./readme_logo.png" width="300"/>

<div align="left" />

# GML Behaviour Tree

The classic Behaviour Tree to GMS 2.3+

## how its builded

Our implementation is maded all over the same BTreeNode struct:

### Variables:

| Name             | Description                        |
|------------------|------------------------------------|
| name             | The node name                      |
| status           | The Current Status of the node     |
| visited          | If it already been visited or not  |
| children         | The node children                  |
| children_arr_len | The actual chidren array lenght    |
| black_board_ref  | The reference to blackboard struct |

### Methods:

| Name                   | Description                                                                |
|------------------------|----------------------------------------------------------------------------|
| Init()                 | Call this for some extra configs when visiting the node for the first time |
| Process()              | Called in every step of the game. Need to return one of the BTStates enum  |
| ChildAdd(BTreeNode)    | Used to add childs to the node                                             |
| NodeProcess(BTreeNode) | Process other nodes                                                        |