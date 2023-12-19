import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;
import ballerina/http;

configurable DatabaseConfig databaseConfig = ?;
public class IdCheckService{
    private mysql:Client db;
    public function init() returns error? {
        self.db = check new (databaseConfig.url,databaseConfig.userName,databaseConfig.password,databaseConfig.defaultdb,databaseConfig.port);
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