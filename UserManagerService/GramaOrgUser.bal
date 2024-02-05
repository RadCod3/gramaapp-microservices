type Meta record {
    string created;
    string location;
    string lastModified;
    string resourceType;
};

type RolesItem record {
    string display;
    string value;
    string \$ref;
};

type Name record {
    string givenName;
    string familyName;
};

type Urn\:scim\:wso2\:schema record {
    // string accountState;
    // string accountLocked;
    string country;
    string userSource;
    string nic;
    string idpType;
    // string failedLoginAttempts;
    // string accountConfirmedTime;
    string address_number;
    string nic_g4;
    // string emailVerified;
    string gid_g4;
    string address_province;
    string lastLogonTime;
    string preferredChannel;
    string address_street;
    // string unlockTime;
    string isReadOnlyUser;
    // string failedLoginAttemptsBeforeSuccess;
    string address_district;
};

type GramaOrgUser record {
    string[] emails;
    Meta meta;
    string[] schemas;
    RolesItem[] roles;
    Name name;
    string id;
    string userName;
    Urn\:scim\:wso2\:schema urn\:scim\:wso2\:schema;
};
