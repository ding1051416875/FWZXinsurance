cordova.define("cordova-plugin-jstoast.JSToast",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            show: function(content){
                exec(
                function(message){//成功回调function
                    console.log(message);
                },
                function(message){//失败回调function
                    console.log(message);
                },
                "JSToast",//feature name
                "show",//action
                [content]//要传递的参数，json格式
                );
            }
        }
});