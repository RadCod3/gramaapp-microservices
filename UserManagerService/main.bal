import ballerina/http;
configurable AsgardeoConfig asgardeoConfig = ?;
DataRetriever dataRetriever = new(asgardeoConfig);


service /getUsers on new http:Listener(9090) {
    
    resource function post getUser(string userID) returns SimpleUser|error {
        InternsOrgUser xx = check dataRetriever.fetchUserData(userID);
        string userName = xx.userName;
        SimpleUser user = {
        email: "user@example.com",
        name: userName,
        id: "123456",
        userName: "john_doe",
        NIC: "123-456-789"
    };
        return user;
    }
}
