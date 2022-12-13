var Web3Auth = (function () {
  function Web3Auth(clientId) {
    this._web3auth = new window.Modal.Web3Auth({
      clientId,
      chainConfig: {
        chainNamespace: "eip155",
        chainId: "0x89",
        rpcTarget: "https://rpc-mainnet.matic.network", // This is the public RPC we have added, please pass on your own endpoint while creating an app
      },
    });
    console.log("constructor", this._web3auth);
  }

  Web3Auth.prototype.initModal = async function () {
    console.log("init");
    await this._web3auth.initModal();
  };

  Web3Auth.prototype.connect = async function () {
    console.log("connect");
    var provider = await this._web3auth.connect();
  };

  Web3Auth.prototype.logout = async function () {
    this._web3auth.logout();
  };

  Web3Auth.prototype.getUserInfo = async function () {
    console.log("getUserInfo");
    const user = await this._web3auth.getUserInfo();
    console.log(user);
  };

  return Web3Auth;
})();
