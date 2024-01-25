# lua-dt
A repository of basic data structures for **Lua 5.4**. 

## Current Implementations
* [Doubly Linked List](https://github.com/ciaabcdefg/lua-dt/wiki/Doubly-Linked-List)
* Dynamic List (ArrayList)
* Stack
* Disjoint Set Union (Union-Find)
* (Possibly more to come.)

## Installation & Usage
### Installation
Move `src\datatypes` to your working directory. To include a `.lua` library file containing the data structure, use the `require` keyword. For example, to import the **doubly linked list `datatypes/list.lua`** library to your current code, include:
```lua
local list = require("datatypes.list")
``` 
at the top of the file.

### Example Usage
(Continued from **Installation**) \
To initialize a **doubly linked list**, we access the library (declared as the global variable `list`) and call the initializer `List.new()` as shown in the code block below:

```lua
local list = require("datatypes.list")
local myList = list.List.new()
``` 
Now we have a doubly linked list named `myList`. Tables returned by initializers have attributes and methods that you can access and invoke as if they were OOP objects. For example, we can push a new element `value` at the back of the list using `pushBack(value)`. Additionally, you can use `print` on the list to display its contents.

#### Code
```lua
local list = require("datatypes.list")
local myList = list.List.new()

myList.pushBack(5)
myList.pushBack("New Element")
print(myList)
```
#### Output
```
[5, New Element]
```
A documentation regarding the implementations is [available here](https://github.com/ciaabcdefg/lua-dt/wiki).

## License
This repository is licensed under the MIT License. Full detail is in the `LICENSE` file. Attribution, while not necessary, is always appreciated.

## Closing Message
This is my first Lua project done in my free time, and is not part of my academic works. Do not expect the project to get frequently updated, as I am the only one working on this. Thank you for checking out my project <3
