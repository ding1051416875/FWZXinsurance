cordova.define("cordova-plugin-email.www.Email",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            sendEmail: function(successCallback, errorCallback,str1,str2,str3,str4){
                exec(
                successCallback,
                errorCallback,
                "Email",//feature name
                "sendEmail",//action
                [str1,str2,str3,str4]//要传递的参数，json格式
                );
            }
        }
});
