# lua-dt
A repository of basic data structures for **Lua 5.4**. 

## Current Implementations
* [Doubly Linked List](https://github.com/ciaabcdefg/lua-dt/wiki/Doubly-Linked-List)
* Dynamic Array (ArrayList)
* Stack
* Queue
* Disjoint Set Union (Union-Find)
* Generic Tree
* (Possibly more to come.)

## Installation & Usage
### Installation
Move `src/datatypes` to your working directory (where your `init.lua` or `main.lua` is located), and in your main `.lua` file, add these two lines at the top. 
```lua
package.path = "datatypes/?.lua;" .. package.path -- include if you want to use the data structures
package.path = "utils/?.lua;" .. package.path  -- include if you want to use the utils lib
```
This is extremely important, as it tells Lua where to look for the required files. There are some data types that are dependent of other data types. For instance, the queue library `(queue.lua)` requires the list library `list.lua` to function. Normally, we will have to require the dependency using the full path, but with the inclusion of the code snippet, we can easily retrieve the libraries without specifying the full path.

To include a `.lua` library file containing the data structure, use the `require` keyword. For example, to import the **doubly linked list `datatypes/list.lua`** library to your current code, include:
```lua
local list = require("list") -- only works if you added the code above
-- or
local list = require("datatypes.list") -- only works for some data types that are independent
``` 

### Example Usage
(Continued from **Installation**) \
To initialize a **doubly linked list**, we access the library (declared as the global variable `list`) and call the initializer `List.new()` as shown in the code block below:

```lua
local list = require("list")
local myList = list.List.new()
``` 
Now we have a doubly linked list named `myList`. Tables returned by initializers have attributes and methods that you can access and invoke as if they were OOP objects. For example, we can push a new element `value` at the back of the list using `pushBack(value)`. Additionally, you can use `print` on the list to display its contents.

#### Code
```lua
local list = require("list")
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
