import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;
import ballerina/http;

configurable DatabaseConfig dbConfig = ?;

public class IdCheckService{
    private mysql:Client db;
    public function init() returns error? {
        self.db = check new (dbConfig.url,dbConfig.userName,dbConfig.password,dbConfig.defaultdb,dbConfig.port);
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
            INSERT INTO Citizen (Userid,NIC, Name, genderID, accountStatusID)
            VALUES (${citizen.UserID},${citizen.NIC}, ${citizen.Name}, ${citizen.genderID}, ${citizen.accountStatusID});`);
        return citizen;
    }

    public function updateRecord(Citizen citizen) returns  Citizen|error{
        _ = check self.db->execute(`UPDATE Citizen
            SET accountStatusID = ${citizen.accountStatusID}
            WHERE Userid =${citizen.UserID};
            `);
        return citizen;
    }
    public function getCitizenByGramaID(string gramaID) returns Citizen[]|error {
        // Execute the SQL query to fetch records based on gramaID
        stream<Citizen, sql:Error?> citizenStream = self.db->query(`
            SELECT * FROM Citizen WHERE gramaID = ${gramaID} and accountStatusID = 2`);

        // Process the stream and convert results to Citizen[] or return error
        return from Citizen citizen in citizenStream
            select citizen;
    }
}