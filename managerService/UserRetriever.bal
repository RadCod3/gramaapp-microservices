import ballerina/http;
type UserConfig record{|
    string userEndpoint;
|};


configurable UserConfig userConfig = ?;
public class UserRetriever{
    public function getUser(string userID) returns SimpleUser|error{
        http:Client userClient = check new (userConfig.userEndpoint);
        SimpleUser|error userResponse = userClient->/getUser(userID=userID);
        if (userResponse is SimpleUser) {
            return userResponse;
        } else {
            return error(userResponse.message());
        }
        
    }
}