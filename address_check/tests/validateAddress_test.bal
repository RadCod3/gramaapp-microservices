import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClient = check new ("http://localhost:9090/");

@test:BeforeGroups {value: ["validateAddress"]}
function before_validate_address_test() {
    io:println("Starting the check status tests");
}

@test:Config {groups: ["validateAddress"]}
function testValidateAddress() {
    json payload = {
        number: "27/20",
        street: "Samudrasanna Place",
        gramaDivision: "wedikanda",
        district: "Colombo",
        province: "Western Province"
    };
    http:Response response = checkpanic testClient->post("/validateAddress/2000654654654", payload);
    test:assertEquals(response.statusCode, 200);
    json result = checkpanic response.getJsonPayload();
    json expected = true;
    test:assertEquals(result, expected);
}

@test:AfterGroups {value: ["validateAddress"]}
function after_validate_address_test() {
    io:println("Completed the check status tests");
}
