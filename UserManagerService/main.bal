import ballerina/http;
configurable AsgardeoConfig asgardeoConfig = ?;
DataRetriever dataRetriever = new(asgardeoConfig);
service /getUsers on new http:Listener(9090) {
    
    resource function post getUser(@http:Payload string userID) returns InternsOrgUser|error {
        InternsOrgUser|error fetchUserData = dataRetriever.fetchUserData(userID);
        return fetchUserData;
    }
}
