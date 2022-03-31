// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract MultiSignatureWallet {

  event Deposit(address indexed sender, uint amount, uint balance);
  event ConfirmTransaction(address indexed owner, uint indexed txIndex);
  event RevokeConfirmation(address indexed owner, uint indexed txIndex);
  event ExecuteTransaction(address indexed owner, uint indexed txIndex);
    event SubmitTransaction(
    address indexed owner,
    uint indexed txIndex,
    address indexed to,
    uint value,
    bytes data
  );

  address[] public owners;
  mapping(address => bool) public isOwner;
  uint public numberConfirmationsRequired;

  struct Transaction {
    address to;
    uint value;
    bytes data;
    bool executed;
    mapping(address => bool) isConfirmed;
    uint numConfirmations;
  }

  Transaction[] public transactions;

  constructor(address[] memory _owners, uint _numConfirmationsRequired) public {
    require(_owners.length > 0, "Owners Required");
    require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "invalid number of required confirmations");

    for (uint i = 0; i < _owners.length; i++) {
      address owner = _owners[i];

      require(owner != address(0), "invalid owner");
      require(!isOwner[owner], "owner not unique");

      isOwner[owner] = true;
      owners.push(owner);

    }
  }

  function () payable external {
    emit Deposit(msg.sender, msg.value, address(this).balance);
  }

  // helper function to easily deposit in Remix IDE
  function deposit() payable external {
    emit Deposit(msg.sender, msg.value, address(this).balance);
  }

  modifier onlyOwner() {
    require(isOwner[msg.sender], "Not a valid owner");
    _;
  }

  modifier txExists(uint _txIndex) {
    require(_txIndex < transactions.length, "tx does not exits");
    _;
  }

  modifier notExecuted(uint _txIndex) {
    require(!transactions[_txIndex].isConfirmed[executed], "tx already executed");
    _;
  }

  modifier notConfirmed(uint _txIndex) {
    require(!transactions[_txIndex].isConfirmed[msg.sender], "tx already confirmed");
    _;
  }

  function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
    uint txIndex = transactions.length;

    Transaction storage newTx = transactions.push();
    newTx.to = _to;
    newTx.value = _value;
    newTx.data = _data;

    emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
  }

  function confirmTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notConfirmed(_txIndex) notExecuted(_txIndex) {
    Transaction storage transaction = transactions[_txIndex];

    transaction.isConfirmed[msg.sender] = true;
    transaction.numConfirmations += 1;

    emit ConfirmTransaction(msg.sender, _txIndex);

  }

  function executeTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {

    Transaction storage transaction = transactions[_txIndex];

    require(transaction.numConfirmations >= numberConfirmationsRequired, "cannot execute tx");
    transaction.executed = true;

    (bool success, ) = transaction.to.call.value(transaction.value)(transaction.data);
    require(success, "tx failed");

    emit ExecuteTransaction(msg.sender, _txIndex);

  }

  function revokeConfirmation() {}
}
