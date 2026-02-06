// SPDX-License-Identifier: GPL-3.0 
pragma solidity >= 0.4.16 < 0.9.0;

/* contract var_test{
    uint public state_var;

    constructor() {
        state_var = 16;
    }
} */

/* contract statevariable{
    uint public count;
    address public owner;
    constructor(){
        count = 0;
        owner = msg.sender;
    }

    function increment() public {
        count = count + 1;
    }
} */

// If we use local variable we have to use pure
contract localvariable{
    function getresult() public pure returns(uint){
        uint local_var1 = 1;
        uint local_var2 = 2;
        uint result = local_var1 + local_var2;
        return result;
    }
}