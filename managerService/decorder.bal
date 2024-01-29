import ballerina/http;

type DecoderConfig record{|
    string decoderEndpoint;
|};


configurable DecoderConfig decoderConfig = ?;

public class Decorder {

    function decode(string accessToken) returns User|error{
        http:Client albumClient = check new (decoderConfig.decoderEndpoint);
        User|error userResponse = albumClient->/userInfo(accessToken = accessToken);
        if (userResponse is User) {
            return userResponse;
        } else {
            return error("Error while decoding the access token");
        }
        
    }
}
