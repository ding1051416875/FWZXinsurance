cordova.define("cordova-plugin-ppt.www.Ppt",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            openPPT: function(successCallback, errorCallback,string){
                exec(
                successCallback,
                errorCallback,
                "PPT",//feature name
                "openPPT",//action
                [string]//要传递的参数，json格式
                );
            }
        }
});
