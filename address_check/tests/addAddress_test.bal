import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClientAddAddress = check new ("http://localhost:9090/");

@test:BeforeGroups {value: ["addAddress"]}
function before_add_address_test() {
    io:println("Starting the check status tests");
}

@test:Config {groups: ["addAddress"]}
function testAddAddress() {
    json payload = {
        number: "50",
        street: "Matha Road",
        gramaDivision: "Narahenpita",
        district: "Colombo",
        province: "Western Province"
    };

    http:Response response = checkpanic testClient->post("/addAddress", payload);
    io:println(response.statusCode);
    io:println(response);
    test:assertEquals(response.statusCode, 201);
}

@test:AfterGroups {value: ["addAddress"]}
function after_add_address_test() {
    io:println("Completed the check status tests");
}
