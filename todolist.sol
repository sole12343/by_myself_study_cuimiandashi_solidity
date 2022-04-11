//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

//insert , update , read from array of structs
contract Todolist {
    struct Todo {
        string text ;
        bool completed ;
    }

    Todo[] public todos ;

    function create (string calldata _text) external {
        todos.push(Todo({text:_text , completed:false})); //给结构体数组插入元素的写法
    }

    function updateText(uint _index, string calldata _text) external {
        //修改结构体数组的内容有两种写法，对应两种gas
        //1.在内存中修改，次数少时gas 低
        todos[_index].text = _text ;
        //2.在存储中修改，次数多时gas低
        Todo storage todo = todos[_index] ;
        todo.text = _text ;
    }

    function get(uint _index) external view returns(string memory , bool){
        //此处如果调用memory 存储todo gas更高，因为赋值todo 需要复制一次数组中数据，返回还需要复制一次数据
        //如果选择storage ，只需要复制一次，等到return只需要读取数据就可以了
        Todo storage todo = todos[_index] ;
        return (todo.text , todo.completed) ;
    }

    function toggleCompleted(uint _index) external {
        todos[_index].completed = !todos[_index].completed ;
    }
}
