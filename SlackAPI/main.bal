import ballerina/http;
public type SlackWebHook record{|
    string URL;
|};

public type Message record{|
    string userId;
    string userName;
    string email;
    string message;
|};
configurable SlackWebHook SLACKURL = ?;
http:Client slackClient = check new (SLACKURL.URL);
service /PostSlackMessage on new http:Listener(9090) {
    resource function post postMessage(@http:Payload Message message) returns http:Ok|error? {
        string msg = string 
        `User ${message.userId} : ${message.userName} 
        on ${message.email} 
        posted ${message.message}`;
        string _ = check slackClient->post("",{
            "text": msg
        });
        return http:OK;
    }
}
