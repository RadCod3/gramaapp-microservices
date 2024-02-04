public type AddressS record{
    string number;
    string street;
    string gramaDivision;
    string district;
    string province;
};
public type SimpleUser record {
    string email;
    string name;
    string id;
    string userName;
    string NIC;
    AddressS address;
};