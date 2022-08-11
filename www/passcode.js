const exec = require('cordova/exec');
const CDVPasscode = {
    show_passcode:function (success){
        exec(success,null,'CDVPasscode','show_passcode',[]);
    },
    close:function (){
        exec(null,null,'CDVPasscode','close',[]);
    }
};
module.exports = CDVPasscode;
