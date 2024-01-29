import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;
import ballerina/http;

configurable DatabaseConfig dbConfig = ?;

public class IdCheckService{

    public function createDB() returns mysql:Client|error{
        return check new (dbConfig.url,dbConfig.userName,dbConfig.password,dbConfig.defaultdb,dbConfig.port);
    }
    public function getRecord(string id) returns Citizen|http:NotFound|error{
        mysql:Client db = check self.createDB();
        Citizen|sql:Error result = db->queryRow(`SELECT * FROM Citizen where id =${id}`);
        _= check db.close();
        if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            return result;
        }
    }

    public function insertRecord(Citizen citizen) returns Citizen|error{
        Citizen|http:NotFound|error result = self.getRecord(citizen.UserID);
        if result is http:NotFound{
            mysql:Client db = check self.createDB();
            _ = check db->execute(`
                INSERT INTO Citizen (Userid,NIC, Name, genderID, accountStatusID, gramaID)
                VALUES (${citizen.UserID},${citizen.NIC}, ${citizen.Name}, ${citizen.genderID}, ${citizen.accountStatusID}, ${citizen.gramaID});`);
            _= check db.close();
        }
        return citizen;
    }

    public function updateRecord(Citizen citizen) returns  Citizen|error{
        mysql:Client db = check self.createDB();
        _ = check db->execute(`UPDATE Citizen
            SET accountStatusID = ${citizen.accountStatusID}
            WHERE Userid =${citizen.UserID};
            `);
        _= check db.close();
        return citizen;
    }
    public function getCitizenByGramaID(string gramaID) returns Citizen[]|error {
        mysql:Client db = check self.createDB();
        // Execute the SQL query to fetch records based on gramaID
        stream<Citizen, sql:Error?> citizenStream = db->query(`
            SELECT * FROM Citizen WHERE gramaID = ${gramaID} and accountStatusID = 2`);
        _= check db.close();
        // Process the stream and convert results to Citizen[] or return error
        return from Citizen citizen in citizenStream
            select citizen;
    }
}