import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

configurable DatabaseConfig databaseConfig = ?;

public class DatabaseService {
    private mysql:Client db;
    public function init() returns error? {
        self.db = check new (databaseConfig.url, databaseConfig.userName, databaseConfig.password, databaseConfig.defaultdb, databaseConfig.port);
    }
    public function insertRequest(RequestEntity request) returns boolean|error {
        _ = check self.db->execute(`
        INSERT INTO request (userID, reason, requestTypeID, policeCheckstatus, 
                             identityCheckstatus, addressCheckstatus, statusID, gramaID)
        VALUES (${request.userID}, ${request.reason}, ${request.requestTypeID},
                ${request.policeCheckstatus}, ${request.identityCheckstatus}, 
                ${request.addressCheckstatus}, ${request.statusID}, ${request.gramaID});`);
        return true;
    }
    public function getRequestByGramaID(int gramaID) returns RequestEntity[]|error {
        // Execute the SQL query to fetch records based on gramaID
        stream<RequestEntity, sql:Error?> requestStream = self.db->query(`
            SELECT * FROM request WHERE gramaID = ${gramaID}`);

        // Process the stream and convert results to Request[] or return error
        return from RequestEntity request in requestStream
            select request;
    }
    public function getRequestByUserID(int userID) returns RequestEntity[]|error {
        // Execute the SQL query to fetch records based on userID
        stream<RequestEntity, sql:Error?> requestStream = self.db->query(`
            SELECT * FROM request WHERE userID = ${userID}`);

        // Process the stream and convert results to RequestEntity[] or return error
        return from RequestEntity request in requestStream
            select request;
    }

    public function getRequestByID(int requestID) returns RequestEntity|error {
        sql:ParameterizedQuery pQuery = `SELECT * FROM request WHERE requestID = ${requestID}`;

        RequestEntity request = checkpanic self.db->queryRow(pQuery, RequestEntity);

        return request;
    }

    public function updateRequest(RequestEntity request) returns http:Created|error {
        _ = check self.db->execute(`
        UPDATE request
        SET userID = ${request.userID},
            reason = ${request.reason},
            requestTypeID = ${request.requestTypeID},
            policeCheckstatus = ${request.policeCheckstatus},
            identityCheckstatus = ${request.identityCheckstatus},
            addressCheckstatus = ${request.addressCheckstatus},
            statusID = ${request.statusID},
            character = ${request.character}
            gramaID = ${request.gramaID}
        WHERE requestID = ${request.requestID};
    `);
        return http:CREATED;
    }

}
