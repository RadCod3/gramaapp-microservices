import ballerina/http;
import ballerina/io;
public class DataRetriever{
    private AccessTokenHnadler accessTokenHnadler;
    private AsgardeoConfig asgardeoConfig;
    public function init(AsgardeoConfig asgardeoConfig) {
        self.accessTokenHnadler = new();
        self.asgardeoConfig = asgardeoConfig;
    }

    public function fetchUserData(string userId) returns InternsOrgUser|error{
        string accessToken = check self.accessTokenHnadler.getToken(self.asgardeoConfig.clientID,self.asgardeoConfig.clientSecret,
            self.asgardeoConfig.scope,self.asgardeoConfig.orgname);
        io:println(accessToken);
        http:Client acessClient = check new ("https://api.asgardeo.io");
        string auth =string `Bearer ${accessToken}`;
        map<string> headers = {
            "accept": "application/scim+json",
            "Authorization": auth
        };
        InternsOrgUser asgardeoUser = check acessClient->get(string `/t/${self.asgardeoConfig.orgname}/scim2/Users/${userId}`,headers);
        return asgardeoUser;

    }
}