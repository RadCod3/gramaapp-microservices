import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

type Address record {
    string number;
    string street;
    string gramaDivision;
    string district;
    string province;
};

type Person record {|
    string nic;
    string firstName;
    string lastName;
    int address;
|};

type DatabaseConfig record {|
    string host;
    int port;
    string user;
    string password;
    string database;
|};

configurable DatabaseConfig dbConfig = ?;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service / on new http:Listener(9090) {
    resource function post validateAddress/[string nic](Address address) returns http:Response|error {
        Person person = check getPersonFunc(nic);
        Address personAddress = check getAddress(person.address);
        boolean isValid = personAddress.number.equalsIgnoreCaseAscii(address.number) &&
                            personAddress.street.equalsIgnoreCaseAscii(address.street) &&
                            personAddress.gramaDivision.equalsIgnoreCaseAscii(address.gramaDivision) &&
                            personAddress.district.equalsIgnoreCaseAscii(address.district) &&
                            personAddress.province.equalsIgnoreCaseAscii(address.province);
        http:Response response = new;
        response.setJsonPayload(isValid);
        response.statusCode = 200;
        return response;

    }

    resource function post addAddress(Address address) returns string|int|error? {
        mysql:Client db = check new (...dbConfig);

        sql:ParameterizedQuery insertAddress = `INSERT INTO address (number, street, gramaDivision, district, province) 
                                                VALUES (${address.number}, ${address.street}, ${address.gramaDivision}, 
                                                ${address.district}, ${address.province})`;

        sql:ExecutionResult result = check db->execute(insertAddress);
        string|int? lastInsertId = result.lastInsertId;
        _ = check db.close();
        return lastInsertId;
    };

    resource function post addPerson(Person person) returns string|int|error? {
        mysql:Client db = check new (...dbConfig);
        sql:ParameterizedQuery insertPerson = `INSERT INTO person (nic, firstName, lastName, address) 
                                                VALUES (${person.nic}, ${person.firstName}, ${person.lastName}, 
                                                ${person.address})`;

        sql:ExecutionResult result = check db->execute(insertPerson);
        string|int? lastInsertId = result.lastInsertId;
        _ = check db.close();
        return lastInsertId;
    };

    resource function get getPerson(string nic) returns Person|error? {

        return check getPersonFunc(nic);
    };

};

function getPersonFunc(string nic) returns Person|error {
    mysql:Client db = check new (...dbConfig);
    sql:ParameterizedQuery selectPerson = `SELECT nic, firstName, lastName, address FROM person WHERE nic = ${nic}`;
    Person person = check db->queryRow(selectPerson);
    _ = check db.close();
    return person;
};

function getAddress(int addressId) returns Address|error {
    mysql:Client db = check new (...dbConfig);
    sql:ParameterizedQuery selectAddress = `SELECT number, street, gramaDivision, district, province FROM address WHERE addressId = ${addressId}`;
    Address address = check db->queryRow(selectAddress);
    _ = check db.close();
    return address;
};
