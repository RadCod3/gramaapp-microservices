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

//configurable DatabaseConfig dbConfig = ?;

// configurable string host = ?;
// configurable string username = ?;
// configurable string database = ?;
// configurable string password = ?;
// configurable int port = ?;
DatabaseConfig dbConfig = {
    host: "mysql-3c6f41ae-56b2-4642-a999-2570552c4e26-gramaapp2685499808-c.a.aivencloud.com",
    user: "avnadmin",
    database: "addresscheck",
    password: "AVNS_Tk19Pj_OOgJi-vfMx1L",
    port: 21801
};

service / on new http:Listener(9090) {
    private final mysql:Client db;
    function init() returns error? {
        self.db = check new (...dbConfig);
    };

    resource function post validateAddress/[string nic](Address address) returns http:Response|error {
        Person person = check getPerson(self.db, nic);
        Address personAddress = check getAddress(self.db, person.address);
        boolean isValid = personAddress.number.equalsIgnoreCaseAscii(address.number) &&
                            personAddress.street.equalsIgnoreCaseAscii(address.street) &&
                            personAddress.gramaDivision.equalsIgnoreCaseAscii(address.gramaDivision) &&
                            personAddress.district.equalsIgnoreCaseAscii(address.district) &&
                            personAddress.province.equalsIgnoreCaseAscii(address.province);
        http:Response response = new;
        response.setJsonPayload(isValid);
        return response;

    }

    resource function post addAddress(Address address) returns string|int|error? {

        sql:ParameterizedQuery insertAddress = `INSERT INTO address (number, street, gramaDivision, district, province) 
                                                VALUES (${address.number}, ${address.street}, ${address.gramaDivision}, 
                                                ${address.district}, ${address.province})`;

        sql:ExecutionResult result = check self.db->execute(insertAddress);
        string|int? lastInsertId = result.lastInsertId;
        return lastInsertId;
    };

    resource function post addPerson(Person person) returns string|int|error? {
        sql:ParameterizedQuery insertPerson = `INSERT INTO person (nic, firstName, lastName, address) 
                                                VALUES (${person.nic}, ${person.firstName}, ${person.lastName}, 
                                                ${person.address})`;

        sql:ExecutionResult result = check self.db->execute(insertPerson);
        string|int? lastInsertId = result.lastInsertId;
        return lastInsertId;
    };

    resource function get getPerson(string nic) returns Person|error? {
        return check getPerson(self.db, nic);
    };
};

function getPerson(mysql:Client db, string nic) returns Person|error {
    sql:ParameterizedQuery selectPerson = `SELECT nic, firstName, lastName, address FROM person WHERE nic = ${nic}`;
    Person person = check db->queryRow(selectPerson);
    return person;
};

function getAddress(mysql:Client db, int addressId) returns Address|error {
    sql:ParameterizedQuery selectAddress = `SELECT number, street, gramaDivision, district, province FROM address WHERE addressId = ${addressId}`;
    Address address = check db->queryRow(selectAddress);
    return address;
};
