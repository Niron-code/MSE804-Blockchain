// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract HelloWorld {
    string private message;

    constructor() {
        message = "hello world";
    }

    function sayHello() public view returns (string memory) {
        return message;
    }
}