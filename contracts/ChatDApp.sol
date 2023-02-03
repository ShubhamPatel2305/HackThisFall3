//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ChatDApp{

    struct user{
        string name;
        friend[] friendList;
    }

    struct friend{
        address pKey;
        string name;
    }

    struct message{
        address from;
        uint256 timestamp;
        string message;
    }

    struct allUsers{
        string name;
        address accountAddress;
    }

    allUsers[] getAllUsers;

    mapping(address => user) userList;
    mapping(bytes32=>message[]) allMessages;

    function checkUserExist(address pkey) public view returns(bool){
         return bytes(userList[pkey].name).length >0;
    }

    function createAcc(string calldata name) external {
        require(checkUserExist(msg.sender) == false , "You have already registered");
        require(bytes(name).length>0 , "Please eneter a name");
        userList[msg.sender].name=name;
        getAllUsers.push(allUsers(name,msg.sender));
    }

    function getUserName(address pKey) external view returns(string memory){
        require(checkUserExist(pKey), "user not registered");
        return userList[pKey].name;
    }

    function addFriend(address fKey, string calldata name) external{
        require(checkUserExist(msg.sender), "You are not a user yet");
        require(checkUserExist(fKey), "user is not yet registered");
        require(msg.sender != fKey, "You cannot make yourself your own friend LMAO");
        require(checkAlreadyFriends(msg.sender, fKey)==false , "You two are already friends");

        _addFriend(msg.sender, fKey, name);
        _addFriend(fKey, msg.sender, userList[msg.sender].name);
    }

    function checkAlreadyFriends(address k1, address k2) internal view  returns(bool){
        if(userList[k1].friendList.length > userList[k2].friendList.length){
            address temp=k1;
            k1=k2;
            k2=temp;
        }

        for(uint256 i=0; i<userList[k1].friendList.length; i++){
            if(userList[k1].friendList[i].pKey==k2){
                return true;
            }
        }
        return false;
    }

    function _addFriend(address self, address fKey, string memory name) internal{
        friend memory newFriend= friend(fKey,name);
        userList[self].friendList.push(newFriend);
    }

    function getMyFriendList() external view returns(friend[] memory) {
        return userList[msg.sender].friendList;
    }

    function _getChatCode(address k1, address k2) internal pure returns(bytes32) {
        if(k1<k2){
            return keccak256(abi.encodePacked(k1,k2));
        }
        else{
            return keccak256(abi.encodePacked(k2,k1));
        }
    }

    function sendMessage(address fKey, string calldata _msg) external{
        require(checkUserExist(msg.sender), "Create an account first");
        require(checkUserExist(fKey), "Your friend has to create an account first");
        require(checkAlreadyFriends(msg.sender, fKey), " You two are not friends.");

        bytes32 chatCode= _getChatCode(msg.sender, fKey);
        message memory newMsg= message(msg.sender, block.timestamp, _msg);
        allMessages[chatCode].push(newMsg);
    }

    function readMessage(address fKey) external view returns(message[] memory){
        bytes32 chatCode= _getChatCode(msg.sender, fKey);
        return allMessages[chatCode];
    }

    function getAllUsersLive() public view returns(allUsers[] memory){
        return getAllUsers;
    }
}