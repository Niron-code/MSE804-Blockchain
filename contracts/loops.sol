// SPDX-License-Identifier: GPL-3.0 
pragma solidity >= 0.4.16 < 0.9.0;

/* contract for_loop_example{
    uint[] data;
    function loop() public returns(uint[] memory){
        for(uint i = 0; i < 5; i++){
            data.push(i);
        }
        return data;
    }
} */

/* contract for_loop_example_2{
    uint[] public arr = [1,2,3];
    function loop_2() public view returns (uint){
        uint total = 0;
        for (uint i=0; i<arr.length; i++){    
            total +=arr[i];
        }
        return total; 
    }
} */

contract while_loop_example{
    uint i = 0;
    uint result = 0;
    function sum() public returns(uint data){
        while(i<3){
            i++;
            result = result + 1;
        }
        return result;
    }
}
