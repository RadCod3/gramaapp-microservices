import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClientGetPerson = check new ("http://localhost:9090/");

@test:BeforeGroups {value: ["getPerson"]}
function before_get_person_test() {
    io:println("Starting the check status tests");
}

@test:Config {groups: ["getPerson"]}
function testGetPerson() {

    http:Response response = checkpanic testClientGetPerson->get("/getPerson/?nic=2000654654654");
    io:println(response.statusCode);
    io:println(response);
    test:assertEquals(response.statusCode, 200);
}

@test:AfterGroups {value: ["getPerson"]}
function after_get_person_test() {
    io:println("Completed the check status tests");
}
