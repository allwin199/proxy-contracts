// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}

// https://solidity-by-example.org/delegatecall/
// since this is a delegate call, storage will be updated in contract A and not in contract B
// if it is call, instead of delegate call, then storgage will updated in contract B not in contract A
// during the delegate call
// contract A and B has same storage layout
// but while delegate call is executed
// _num will be stored in 1st slot of contract A
// msg.sender will be stored in 2nd slot of contract A
// contract A {
    // uint public firstVal;
    // address public anotherVal;
    // uint public somevalue;
// }
// now contract A and B has different storage layout
// since it is delegate call
// _num will be stored in 1st slot of contract A, which is firstVal
// msg.sender will be stored in 2nd slot of contract A, which is anotherVal
