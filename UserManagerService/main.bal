import ballerina/http;
configurable AsgardeoConfig asgardeoConfig = ?;
service /Users on new http:Listener(9090) {
    private DataRetriever dataRetriever;
    function init() returns error? {
        self.dataRetriever =  new(asgardeoConfig);
    }
    resource function post getUser(string userID) returns InternsOrgUser|error? {
        InternsOrgUser|error? fetchUserData = self.dataRetriever.fetchUserData(userID);
        return fetchUserData;
    }
}
