import ballerina/http;
public class AccessTokenHnadler{
    private Base64Encoder base64Encoder;
    public function init() {
        self.base64Encoder  = new ();
    }
    public function getToken(string clientID,string clientSecret,string scope,string org) returns string|error{
        map<string> headers = {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization":self.base64Encoder.ecodeCreds(clientID,clientSecret)
        };
        string body =string `grant_type=client_credentials&scope=${scope}`;
        http:Client acessClient = check new ("https://api.asgardeo.io");
        Response response = check acessClient->post(string `/t/${org}/oauth2/token`,body,headers);
        return response.access_token;
    }
}