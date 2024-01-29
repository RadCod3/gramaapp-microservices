import ballerina/http;
configurable AsgardeoConfig asgardeoConfig = ?;
DataRetriever dataRetriever = new(asgardeoConfig);


service /getUsers on new http:Listener(9090) {
    
    resource function post getUser(string userID) returns SimpleUser|error {
        InternsOrgUser xx = check dataRetriever.fetchUserData(userID);
        string userName = xx.userName;
        SimpleUser user = {
        email: xx.emails[0],
        name: xx.name.givenName+xx.name.familyName,
        id: xx.id,
        userName: xx.userName,
        NIC: xx.id
    };
        return user;
    }
}
