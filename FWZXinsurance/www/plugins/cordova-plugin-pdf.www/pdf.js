cordova.define("cordova-plugin-pdf.www.Pdf",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            openPDF: function(successCallback, errorCallback,string){
                exec(
                successCallback,
                errorCallback,
                "PDF",//feature name
                "openPDF",//action
                [string]//要传递的参数，json格式
                );
            }
        }
});
