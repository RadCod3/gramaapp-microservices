public class Base64Encoder{


    public function encode(string input) returns string{
        byte[] inputArr = input.toBytes();
        string encodedString = inputArr.toBase64();
        return encodedString;
    }

    public function ecodeCreds(string clientId,string clientSecret) returns string{

        string cred = string `${clientId}:${clientSecret}`;
        string encodedcreds = self.encode(cred);
        return string `Basic ${encodedcreds}`;
    }
}