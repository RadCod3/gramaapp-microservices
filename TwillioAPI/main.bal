import ballerina/http;
import ballerinax/twilio;

configurable TwillioAccount twillioAccount = ?;

twilio:ConnectionConfig twilioConfig = {
    twilioAuth:{
        accountSId: twillioAccount.accountSid,
        authToken: twillioAccount.authToken
    }
};

twilio:Client twilioClient = check  new (twilioConfig);
service /twillio on new http:Listener(9090) {
    resource function post sendSMS(@http:Payload SMS sms) returns http:Ok|error? {
        twilio:SmsResponse _ = check twilioClient->sendSms(twillioAccount.myNumber,sms.toNumber,sms.message);
        return http:OK;
    }
}
