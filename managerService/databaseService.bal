import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

configurable DatabaseConfig dbConfig = ?;

public class DatabaseService {
    public function createDB() returns mysql:Client|error{
        return check new (dbConfig.url,dbConfig.userName,dbConfig.password,dbConfig.defaultdb,dbConfig.port);
    }
    public function getRecord(string id) returns Citizen|http:NotFound|error{
        mysql:Client db = check new (dbConfig.url,dbConfig.userName,dbConfig.password,dbConfig.citizendb,dbConfig.port);
        Citizen|sql:Error result = db->queryRow(`SELECT * FROM Citizen where id =${id}`);
        _= check db.close();
        if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            return result;
        }
    }
    public function insertCitizen(Citizen citizen) returns Citizen|error{
        Citizen|http:NotFound|error result = self.getRecord(citizen.UserID);
        if result is http:NotFound{
            mysql:Client db = check new (dbConfig.url,dbConfig.userName,dbConfig.password,dbConfig.citizendb,dbConfig.port);
            _ = check db->execute(`
                INSERT INTO Citizen (Userid,NIC, Name, genderID, accountStatusID, gramaID)
                VALUES (${citizen.UserID},${citizen.NIC}, ${citizen.Name}, ${citizen.genderID}, ${citizen.accountStatusID}, ${citizen.gramaID});`);
            _= check db.close();
        }
        return citizen;
    }
    public function insertRequest(RequestEntity request) returns boolean|error {
        mysql:Client db = check self.createDB();
        _ = check db->execute(`
        INSERT INTO request (userID, reason, requestTypeID, policeCheckstatus, 
                             identityCheckstatus, addressCheckstatus, statusID, gramaID)
        VALUES (${request.userID}, ${request.reason}, ${request.requestTypeID},
                ${request.policeCheckstatus}, ${request.identityCheckstatus}, 
                ${request.addressCheckstatus}, ${request.statusID}, ${request.gramaID});`);
        _= check db.close();
        return true;
    }
    public function getRequestByGramaID(string gramaID) returns RequestEntity[]|error {
        // Execute the SQL query to fetch records based on gramaID
        mysql:Client db = check self.createDB();
        stream<RequestEntity, sql:Error?> requestStream = db->query(`
            SELECT * FROM request WHERE gramaID = ${gramaID}`);

        // Process the stream and convert results to Request[] or return error
        _= check db.close();
        return from RequestEntity request in requestStream
            select request;
    }
    public function getRequestByUserID(string userID) returns RequestEntity[]|error {
        mysql:Client db = check self.createDB();
        // Execute the SQL query to fetch records based on userID
        stream<RequestEntity, sql:Error?> requestStream = db->query(`
            SELECT * FROM request WHERE userID = ${userID}`);

        // Process the stream and convert results to RequestEntity[] or return error
        _= check db.close();
        return from RequestEntity request in requestStream
            select request;
    }

    public function getRequestByID(int requestID) returns RequestEntity|error {
        mysql:Client db = check self.createDB();
        sql:ParameterizedQuery pQuery = `SELECT * FROM request WHERE requestID = ${requestID}`;

        RequestEntity request = checkpanic db->queryRow(pQuery, RequestEntity);
        _= check db.close();

        return request;
    }

    public function updateRequest(RequestEntity request) returns http:Created|error {
        mysql:Client db = check self.createDB();
        _ = check db->execute(`
        UPDATE request
        SET userID = ${request.userID},
            reason = ${request.reason},
            requestTypeID = ${request.requestTypeID},
            policeCheckstatus = ${request.policeCheckstatus},
            identityCheckstatus = ${request.identityCheckstatus},
            addressCheckstatus = ${request.addressCheckstatus},
            statusID = ${request.statusID},
            characterW = ${request.characterW},
            gramaID = ${request.gramaID}
        WHERE requestID = ${request.requestID};
    `);
        _= check db.close();
        return http:CREATED;
    }

}
