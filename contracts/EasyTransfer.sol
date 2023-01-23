// SPDX-License-Identifier: MIT
// Creator: Amar
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract EasyTransfer{
  
   address payable public admin;
   uint public usage_fee;
   
   constructor(uint fee){
       admin=payable(msg.sender);
       usage_fee = fee;
   }

   function register(address NFT_ , address[] memory receivers_ , uint[] memory tokenID) payable external returns(bool){
      ERC721 nftcontract = ERC721(NFT_);

      assert(receivers_.length==tokenID.length);
      require(msg.value>=usage_fee,"The contract fee is insufficient");
      require(NFT_!=address(0),"NFt address is invalid");

      // transfering all the tokens fron the owner to smart contract
      for(uint i; i<tokenID.length;i++){
         nftcontract.transferFrom(msg.sender,receivers_[i],tokenID[i]);
      }
       admin.transfer(usage_fee);
       return true;
   }

}
