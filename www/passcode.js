const exec = require('cordova/exec');
const CDVPasscode = {
    init_passcode:function (){
        exec(null,null,'CDVPasscode','init_passcode',[]);
    },
    show_passcode:function (success){
        exec(success,null,'CDVPasscode','show_passcode',[]);
    },
    change_passcode:function (){
        exec(null,null,'CDVPasscode','change_passcode',[]);
    },
    del_passcode:function (){
        exec(null,null,'CDVPasscode','del_passcode',[]);
    },
    close:function (){
        exec(null,null,'CDVPasscode','close',[]);
    },
    has_passcode:function (success){
        exec(success,null,'CDVPasscode','has_passcode',[]);
    }
};
module.exports = CDVPasscode;
