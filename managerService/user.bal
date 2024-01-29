type Address record {
    string country?;
    string number?;
    string street?;
    string gramaDivision?;
    string district?;
    string province?;
};

public type User record {|
    string sub?;
    string gid_g4?;
    Address address?;
    string[] roles?;
    string userid?;
    string email?;
    string username?;
    string nic_g4?;
|};