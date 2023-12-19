import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClientAddPerson = check new ("http://localhost:9090/");

@test:BeforeGroups {value: ["addPerson"]}
function before_add_person_test() {
    io:println("Starting the check status tests");
}

@test:Config {groups: ["addPerson"]}
function testAddPerson() {
    json payload = {
         nic : "200063636363",
         firstName : "Himanshi",
         lastName : "De Silva",
         address : 3
    };

    http:Response response = checkpanic testClientAddPerson->post("/addPerson", payload);
    io:println(response.statusCode);
    io:println(response);
    test:assertEquals(response.statusCode, 201);
}

@test:AfterGroups {value: ["addPerson"]}
function after_add_person_test() {
    io:println("Completed the check status tests");
}
