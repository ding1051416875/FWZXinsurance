cordova.define("cordova-plugin-pen.www.Pen",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            doSign: function(successCallback, errorCallback,customer,policy,seqNum,url){
                exec(
                successCallback,
                errorCallback,
                "Pen",//feature name
                "doSign",//action
                 [customer,policy,seqNum,url]//要传递的参数，json格式
                );
            }
        }
});
