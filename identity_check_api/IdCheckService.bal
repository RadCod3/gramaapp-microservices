import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;
import ballerina/http;

//configurable DatabaseConfig dbConfig = ?;

type DatabaseConfig record {|
    string host;
    int port;
    string user;
    string password;
    string database;
|};

DatabaseConfig dbConfig = {
    host : "mysql-24a3cfbc-25bf-4e11-9c0e-4122605a9541-idchecks438588230-ch.a.aivencloud.com",
    user : "avnadmin",
    password : "AVNS_jo43GNj-DQkr7upsIge",
    database : "defaultdb",
    port : 17768
};



public class IdCheckService{
    private mysql:Client db;
    public function init() returns error? {
        self.db = check new (dbConfig.host,dbConfig.user,dbConfig.password,dbConfig.database,dbConfig.port);
    }

    public function getRecord(string id) returns Citizen|http:NotFound|error{
        Citizen|sql:Error result = self.db->queryRow(`SELECT * FROM Citizen where id =${id}`);
        if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            return result;
        }
    }

    public function insertRecord(Citizen citizen) returns Citizen|error{
        _ = check self.db->execute(`
            INSERT INTO Citizen (id, Name, genderID, accountStatusID)
            VALUES (${citizen.id}, ${citizen.Name}, ${citizen.genderID}, ${citizen.accountStatusID});`);
        return citizen;
    }

    public function updateRecord(Citizen citizen) returns  Citizen|error{
        _ = check self.db->execute(`UPDATE Citizen
            SET accountStatusID = ${citizen.accountStatusID}
            WHERE id =${citizen.id};
            `);
        return citizen;
    }
}