type Address record {
    string country;
};

type User record {
    string sub;
    string gid_g4;
    Address address;
    string[] roles;
    string userid;
    string email;
    string username;
    string nic_g4;
    string address_province;
    string address_street;
    string address_district;
    string address_number;
};
