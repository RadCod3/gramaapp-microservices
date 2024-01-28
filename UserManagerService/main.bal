import ballerina/http;
configurable AsgardeoConfig asgardeoConfig = ?;
service /getUsers on new http:Listener(9090) {
    private DataRetriever dataRetriever;
    function init() returns error? {
        self.dataRetriever =  new(asgardeoConfig);
    }
    resource function get getUser(string userID) returns InternsOrgUser|error {
        InternsOrgUser|error fetchUserData = self.dataRetriever.fetchUserData(userID);
        return fetchUserData;
    }
}
