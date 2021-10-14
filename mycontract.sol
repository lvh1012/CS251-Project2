// SPDX-License-Identifier: GPL-3.0
// Coded by hoang.lv173128
pragma solidity >=0.7.0 <0.9.0;

contract MyContract{
    // Thong tin Creditor
    struct Creditor { 
        address creditor;
        int amount;
        uint time;
    }
    
    mapping (address => Creditor[]) public creditors; // Mot debtor tro den mot mang cac creditor
    address[] public debtors; // Danh sach cac debtor
    address[] public users; // Danh sach cac user
    
    function addUser(address _user) public {
        for (uint i=0; i < users.length; i++) {
            if (users[i] == _user){
                return;
            }
        }
        users.push(_user);
    }
    
    function addDebtor(address _debtor) public {
        for (uint i=0; i < debtors.length; i++) {
            if (debtors[i] == _debtor){
                return;
            }
        }
        debtors.push(_debtor);
    }
    
    function addCreditor(address _creditor, int _amount, uint _time) public {
        for (uint i=0; i < creditors[msg.sender].length; i++) {
            if (creditors[msg.sender][i].creditor == _creditor){
                creditors[msg.sender][i].amount += _amount;
                creditors[msg.sender][i].time = _time;
                return;
            }
        }
        creditors[msg.sender].push(Creditor(_creditor, _amount, _time));
    }
    
    function addIOU(address _creditor, int _amount, uint _time) public {
        addCreditor(_creditor, _amount, _time);
        addUser(msg.sender);
        addUser(_creditor);
        addDebtor(msg.sender);
        
    }
    
    function getUsers() public view returns (address[] memory){
        return(users);
    }
    
    function lookup(address _debtor, address _creditor) public view returns (int){
        int rs = 0;
        for (uint i=0; i < creditors[_debtor].length; i++) {
            if (creditors[_debtor][i].creditor == _creditor){
                rs = creditors[_debtor][i].amount;
                break;
            }
        }
        return(rs);
    }
    
    function getNeighbors(address _user) public view returns (address[] memory){
        address[] memory neighbors = new address[](creditors[_user].length);
        for (uint i=0; i < creditors[_user].length; i++) {
            neighbors[i] = creditors[_user][i].creditor;
        }
        return(neighbors);
    }
    
    function getTotalOwed(address _debtor) public view returns (int){
        uint arrayLength = creditors[_debtor].length;
        int total = 0;
        for (uint i=0; i < arrayLength; i++) {
            total += creditors[_debtor][i].amount;
        }
        return total;
    }
    
    function getLastActive(address _user) public view returns (uint){
        uint rs = 0;
        uint arrayLength = creditors[_user].length;
        for (uint i=0; i<arrayLength; i++) {
            if (creditors[_user][i].time > rs){
                rs = creditors[_user][i].time ;
            }
        }
        return rs;
    }
}