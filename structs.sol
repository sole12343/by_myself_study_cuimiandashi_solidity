//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7 ;

contract Structs{
    struct Car {
        string model ;
        uint year ;
        address owner ;
    }//定义结构体Car

    Car public car ;//定义一个结构体 变量
    Car[] public cars ;//定义一个结构体数组
    mapping(address => Car[]) public carsByowner ;//一个地址变量到结构体变量的映射carsByowner

    function example() external {
        //三种给结构体变量赋值的方法
        Car memory toyota = Car("Toyota", 1990, msg.sender) ;
        Car memory lambo = Car({year : 1980 , model : "Lamborghini", owner:msg.sender});
        Car memory tesla ;
        tesla.model = "Tesla" ;
        tesla.year = 2010 ;
        tesla.owner = msg.sender ;

        //将三个变量的值放进结构体数组
        cars.push(toyota) ;
        cars.push(lambo) ;
        cars.push(tesla) ;

        //直接赋值并且推入数组的方法
        cars.push(Car("Ferrari", 2020, msg.sender)) ;

        Car storage _car = cars[0] ;//取值
        _car.year = 1999 ;//修改结构体数组的值
        delete _car.owner ;//删除结构体数组的值

        delete cars[1] ;//删除结构体数组中间一个结构体的全部值

    }
}
