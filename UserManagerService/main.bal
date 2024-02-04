import ballerina/http;
configurable AsgardeoConfig asgardeoConfig = ?;
DataRetriever dataRetriever = new(asgardeoConfig);


service /getUsers on new http:Listener(9090) {
    
    resource function get getUser(string userID) returns SimpleUser|error {
        GramaOrgUser  gramaOrgUser =  check dataRetriever.fetchUserData(userID);
        SimpleUser user = {
        email: gramaOrgUser.emails[0],
        name: gramaOrgUser.name.givenName+gramaOrgUser.name.familyName,
        id: gramaOrgUser.id,
        userName: gramaOrgUser.userName,
        NIC: gramaOrgUser.urn\:scim\:wso2\:schema.nic_g4
    };
        return user;
    }
}
