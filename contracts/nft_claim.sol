// SPDX-License-Identifier: MIT
// Creator: Amar
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleNFTClaim {

   struct receiver_details{
       address NFT_;
       address owner;
       address receiver;
       uint tokenID;
       // status is used for owner confirmation of the NFT
       bool claim_status;
   }
   event logs(address nft , uint tokenID , uint last_update_time , bool transfer_status);

   mapping(address=> mapping (uint => receiver_details)) private receivers;

   address payable private admin;
   uint public usage_fee;
   
   constructor(uint fee){
       admin=payable(msg.sender);
       usage_fee = fee;
   }

   modifier onlyadmin(){
       require(msg.sender==admin,"you are not the admin");
       _;
   }
   
//gas consumption might be more but the security is given more preference
   function register(address NFT_ , address[] memory receivers_ , uint[] memory tokenID) payable external returns(bool){
      ERC721 nftcontract = ERC721(NFT_);
      assert(receivers_.length==tokenID.length);
      require(msg.value>=usage_fee,"The contract fee is insufficient");
      require(NFT_!=address(0),"NFt address is invalid");

      // transfering all the tokens fron the owner to smart contract
      // upting the receivers mapping for the claim
      for(uint i; i<tokenID.length;i++){
         nftcontract.transferFrom(msg.sender,address(this),tokenID[i]);
         receivers[NFT_][tokenID[i]]=receiver_details(NFT_,msg.sender,receivers_[i],tokenID[i],true);
         emit logs(NFT_,tokenID[i],block.timestamp,false);
      }
      // admin.transfer(usage_fee);
      return true;
   }
   
// claiming single NFT from the user
    function NFT_claim(address NFT_ , uint tokenID) external returns (bool){
       ERC721 nftcontract = ERC721(NFT_);
       require(receivers[NFT_][tokenID].receiver==msg.sender,"You are not the owner of the token");
       nftcontract.transferFrom(address(this),msg.sender,tokenID);
       receivers[NFT_][tokenID]=receiver_details(NFT_,address(0),address(0),tokenID,false);
       emit logs(NFT_,tokenID,block.timestamp,true);
       return true;
      }

//receivers for whom the NFT is set can claim the NFT
   function NFT_claim_All(address NFT , uint[] memory tokenID) external returns(bool){
       ERC721 nftcontract = ERC721(NFT);

       for(uint i ;i<tokenID.length;i++){
       assert(receivers[NFT][tokenID[i]].claim_status==true);
       require(receivers[NFT][tokenID[i]].receiver==msg.sender,"There are no NFTs registered on your address");
       nftcontract.transferFrom(address(this),msg.sender,receivers[NFT][tokenID[i]].tokenID);
       receivers[NFT][tokenID[i]]=receiver_details(NFT,address(0),address(0),tokenID[i],false);
       emit logs(NFT,tokenID[i],block.timestamp,true);
       } 
       return true;
   }

// only NFT owner can withdraw the NFT's
   function NFT_withdraw(address NFT , uint tokenID) external returns(bool){
       assert(receivers[NFT][tokenID].claim_status==true);
       require(msg.sender==receivers[NFT][tokenID].owner,"You are not the owner of the NFT");
       ERC721 nftcontract = ERC721(NFT);
       nftcontract.transferFrom(address(this),msg.sender,tokenID);
       receivers[NFT][tokenID]=receiver_details(NFT,address(0),address(0),tokenID,false);
       return true;
   }

// NFT withdraw of all the NFTs
   function NFT_withdraw_All(address NFT , uint[] memory tokenID) external returns(bool){
       ERC721 nftcontract = ERC721(NFT);
       for(uint i ;i<tokenID.length;i++){
         assert(receivers[NFT][tokenID[i]].claim_status==true);
         require(msg.sender==receivers[NFT][tokenID[i]].owner,"You are not the owner of the NFT");
         nftcontract.transferFrom(address(this),msg.sender,tokenID[i]);
         receivers[NFT][tokenID[i]]=receiver_details(NFT,address(0),address(0),tokenID[i],false);        
       }
       return true;
   }

// withdraw the money from the contract
   function admin_withdrawal() external onlyadmin{
       admin.transfer(address(this).balance);
   }
// change of ownership
   function changeowner(address payable admin_) external onlyadmin{
       admin=admin_;
   } 
}
