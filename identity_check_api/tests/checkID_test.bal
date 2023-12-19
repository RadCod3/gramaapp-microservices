//Writing tests for checkid
import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClient = check new ("http://localhost:8080/idCheck");

@test:BeforeGroups {value: ["checkid"]}
function before_check_status_test() {
    io:println("Starting the check status tests");
}
@test:Config {groups: ["checkid"]}
function testforcheckid() {
    json payload={
        id:"987654321V"
    };
    http:Response response = checkpanic testClient->post("/checkid", payload);
    test:assertEquals(response.statusCode, 201);
    json result = checkpanic response.getJsonPayload();
    json expected = {requestid:1,id:"987654321V",statusCode:0,description:"Valid and Active"};
    test:assertEquals(result, expected);
}

@test:AfterGroups {value: ["checkid"]}
function after_check_status_test() {
    io:println("Completed the check status tests");
}