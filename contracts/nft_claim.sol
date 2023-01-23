// SPDX-License-Identifier: MIT
// Creator: Amar
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleNFTClaim {

   struct receiver_details{
       address NFT_;
       uint tokenID;
       // status is used for owner confirmation of the NFT
        bool status;
   }
   mapping(address=> receiver_details) public receivers;
   address payable public admin;
   uint public usage_fee;
   
   constructor(uint fee){
       admin=payable(msg.sender);
       usage_fee = fee;
   }

   modifier onlyadmin(){
       require(msg.sender==admin,"you are not the admin");
       _;
   }

   function register(address NFT_ , address[] memory receivers_ , uint[] memory tokenID) payable external returns(bool){
      ERC721 nftcontract = ERC721(NFT_);

      assert(receivers_.length==tokenID.length);
      require(msg.value>=usage_fee,"The contract fee is insufficient");
      require(NFT_!=address(0),"NFt address is invalid");

      // transfering all the tokens fron the owner to smart contract
      for(uint i; i<tokenID.length;i++){
         nftcontract.transferFrom(msg.sender,address(this),tokenID[i]);
      }
      //upting the receivers mapping for the claim
      for(uint i; i<receivers_.length;i++){
          receivers[receivers_[i]]=receiver_details(NFT_,tokenID[i],true);      
      }
      // admin.transfer(usage_fee);
      return true;
   }

   function NFTclaim() external returns(bool){
       address receiver_addr=msg.sender;
       require(receivers[receiver_addr].status,"There are no NFTs registered on your address");
      
       ERC721 nftcontract = ERC721(receivers[receiver_addr].NFT_);
       nftcontract.transferFrom(address(this),receiver_addr,receivers[receiver_addr].tokenID);

       receivers[receiver_addr]=receiver_details(address(0),0,false);
       return true;
   }

   function withdrawal() external onlyadmin{
       admin.transfer(address(this).balance);
   }

   function changeowner(address payable admin_) external onlyadmin{
       admin=admin_;
   } 

}
