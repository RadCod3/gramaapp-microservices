import ballerina/http;
import ballerina/io;

type Address record {
    string country?;
    string number?;
    string street?;
    string gramaDivision?;
    string district?;
    string province?;
};

// Add fields in asgardeo User Attributes
type UserInfo record {
    string sub?;
    string gid_g4?;
    Address address?;
    string[] roles?;
    string userid?;
    string email?;
    string username?;
    string nic_g4?;
};


type AsgardeoConfig record {|
    string asgardeoEndpoint;
|};

configurable AsgardeoConfig asgardeoConfig = ?;

service / on new http:Listener(9090) {
    # Get user info from asgardeo
    # + accessToken - string
    # + return - json object with user info
    resource function get userInfo(string accessToken) returns UserInfo|error {

        http:BearerTokenConfig authConfig = {token: accessToken};
        http:Client asgardeoClient = check new (asgardeoConfig.asgardeoEndpoint, {
            auth: authConfig
        });
        UserInfo|http:ClientError response = asgardeoClient->get("/userinfo");
        if (response is http:ClientError) {
            io:println(response.message());
            return error("Error occurred while getting user info from asgardeo");
        }
        io:println(response);
        return response;

    };
}
