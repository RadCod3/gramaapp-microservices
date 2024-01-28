public class Decorder {

    function decode(string accessToken) returns User|error{
        User dummyUser = {
        userId: 1,
        firstName: "John",
        lastName: "Doe",
        address: "123 Main Street",
        gramaAreaId: "MG_01"
        };
        return dummyUser;
    }
}
