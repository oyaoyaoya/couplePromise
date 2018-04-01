pragma solidity ^0.4.17;
contract CouplePromise {
    // 2人とも成功 => お金が返る
    // 1人失敗 => もう一人にお金が渡る
    // 2人とも失敗　=> プールされる
    struct Promise {
        address firstPerson;
        address secondPerson;
        uint firstPersonAmount;
        uint secondPersonAmount;
        bool firstPersonAchieved;
        bool secondPersonAchieved;
        uint etherMount;
        uint deadline;
        bool checked;
    }

    uint promiseCount;
    // uint constant coupleNum = 2;
    function CouplePromise() public {
        promiseCount = 0;
    }

    event showPromise(uint _id, address _firstPerson, address _secondPerson, uint etherMount);
    mapping(uint => Promise) promises;

    modifier onlyApplicableUser(uint _id) {
        var promise = promises[_id];
        require(promise.firstPerson == msg.sender || promise.secondPerson == msg.sender);
        _;
    }

    function countPromise() public view returns(uint){
        return promiseCount;
    }

    function createPromise(address _opponent) public{
        Promise storage pro = promises[promiseCount];
        pro.firstPerson = msg.sender;
        pro.secondPerson = _opponent;
        pro.deadline = now + 1 minutes;
        promiseCount++;
    }

    function getPromise(uint _id) public view returns(uint, address, address, uint, uint, bool, bool, uint){
        var promise = promises[_id];
        return(_id, promise.firstPerson, promise.secondPerson, promise.firstPersonAmount, promise.secondPersonAmount, promise.firstPersonAchieved, promise.secondPersonAchieved, promise.etherMount);
    }

    function firstPersonBet(uint _id) private {
        var promise = promises[_id];
        promise.firstPersonAmount = msg.value;
        promise.etherMount += msg.value;

    }

    function secondPersonBet(uint _id) private {
        var promise = promises[_id];
        promise.secondPersonAmount = msg.value;
        promise.etherMount += msg.value;
    }

    function betPromise(uint _id) onlyApplicableUser(_id) public payable{
        var promise = promises[_id];
        if (promise.firstPerson == msg.sender){
            firstPersonBet(_id);
        } else {
            secondPersonBet(_id);
        }
    }

    function firstPersonAchived(uint _id) private {
        var promise = promises[_id];
        promise.firstPersonAchieved = true;
    }

    function secondPersonAchieved(uint _id) private {
        var promise = promises[_id];
        promise.secondPersonAchieved = true;
    }

    function achivedPromise(uint _id) public onlyApplicableUser(_id) {
        var promise = promises[_id];
        if (promise.firstPerson == msg.sender){
            firstPersonAchived(_id);
        } else {
            secondPersonAchieved(_id);
        }
    }

    function checkPromise(uint _id) public onlyApplicableUser(_id) {
        var promise = promises[_id];
        require(promise.deadline < now);
        if(promise.firstPersonAchieved == true && promise.secondPersonAchieved == true) {

        }else if (promise.firstPersonAchieved == true && promise.secondPersonAchieved == false) {
            promise.firstPersonAmount += promise.secondPersonAmount;
            promise.secondPersonAmount = 0;
        }else if (promise.firstPersonAchieved == false && promise.secondPersonAchieved == true) {
            promise.secondPersonAmount += promise.firstPersonAmount;
            promise.firstPersonAmount = 0;
        } else {
            promise.firstPersonAmount = 0;
            promise.secondPersonAmount = 0;
        }
        promise.checked = true;
    }

    function withdrawPromise(uint _id) public onlyApplicableUser(_id) payable {
        var promise = promises[_id];
        if ( (msg.sender == promise.firstPerson) && !(promise.firstPersonAmount == 0) ) {
            uint firstAmount = promise.firstPersonAmount;
            promise.firstPersonAmount = 0;
            if( !(msg.sender.call.value(firstAmount)())) { revert(); }
        } else if ( (msg.sender == promise.secondPerson) && !(promise.secondPersonAmount == 0) ){
            uint secondAmount = promise.secondPersonAmount;
            promise.secondPersonAmount = 0;
            if(!(msg.sender.call.value(secondAmount)())) { revert(); }
        } else {
        }
    }
    /* function retunSender() public view returns(address){
      return msg.sender;
    }

    function sendValue(uint _id) public payable returns(uint) {
    var promise = promises[_id];
      promise.etherMount+=msg.value;
    } */
}
