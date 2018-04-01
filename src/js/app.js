App = {
  web3Provider: null,
  contracts: {},
  account: null,

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('CouplePromise.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var CouplePromiseArtifact = data;
      App.contracts.CouplePromise = TruffleContract(CouplePromiseArtifact);

      // Set the provider for our contract
      App.contracts.CouplePromise.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
    });
    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn', function(event) {
      event.preventDefault();
      var eventName = $(this).data("event");
      if (eventName == "setAcc") {
        web3.eth.getAccounts(function(err, res) {
          debugger;
          account = res[0];
        })
      }else if (eventName == "createPro") {
        App.createPro();
      }else if (eventName == "getPro") {
        App.getPro;
      }
    })

    // $(document).on('click', '.btn-create-promise', App.creratePro);
    // $(document).on('click', '.btn-get-promise', App.getPro);
  },

  createPro: function() {
    debugger;
    // web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      var account = accounts[0];
      App.contracts.CouplePromise.deployed().then(function(instance) {
        var temp_address = $(".promise-address")[0].value;
        var coupleInstance;
        coupleInstance = instance;
        debugger;
        // coupleInstance.createPromise(temp_address, {from:account});
        // Execute adopt as a transaction by sending account
      }).then(function(result) {

      }).catch(function(err) {
        console.log(err.message);
      });
    // });
  },

  getPro: function(event) {
    debugger;
    // web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      console.log("un");
      App.contracts.CouplePromise.deployed().then(function(instance) {
        var promise_id = $(".promise-id")[0].value;
        var coupleInstance;
        coupleInstance = instance;
        // coupleInstance.getPromise(promise_id).call;
        // Execute adopt as a transaction by sending account
      }).then(function(result) {
      }).catch(function(err) {
        console.log(err.message);
      });
    // });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
