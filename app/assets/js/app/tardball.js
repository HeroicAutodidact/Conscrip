var do_i_compile, gawk, roger;

gawk = function(lookAt) {
  return console.log("Look at that " + lookAt);
};

roger = (function() {
  roger.mom = 2;

  function roger() {
    this.todd = "todd";
  }

  roger.prototype.vibrate = function() {
    return console.log("I'm vibrating");
  };

  roger.prototype.sing = function() {
    return console.log("ham");
  };

  return roger;

})();

do_i_compile = false;
