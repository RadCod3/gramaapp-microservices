import ballerina/io;
configurable AsgardeoConfig asgardeoConfig = ?;
public function main() {
    DataRetriever dataRetriever = new(asgardeoConfig);
    error? fetchUserData = dataRetriever.fetchUserData("117f85eb-6463-4325-9673-b585c7017ccb");
    if fetchUserData is error {
        io:println(fetchUserData);
    }

}
