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
        NIC: gramaOrgUser.urn\:scim\:wso2\:schema.nic_g4,
        number: gramaOrgUser.urn\:scim\:wso2\:schema.address_number, 
        gramaDivision: gramaOrgUser.urn\:scim\:wso2\:schema.gid_g4, 
        province: gramaOrgUser.urn\:scim\:wso2\:schema.address_province, 
        street: gramaOrgUser.urn\:scim\:wso2\:schema.address_street, 
        district: gramaOrgUser.urn\:scim\:wso2\:schema.address_district
        };
        return user;
    }
}
