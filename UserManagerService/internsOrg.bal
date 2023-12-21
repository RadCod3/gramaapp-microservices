public type Meta record {|
    string created;
    string location;
    string lastModified;
    string resourceType;
|};

public type RolesItem record {|
    string display;
    string value;
    string \$ref;
|};

public type Name record {|
    string givenName;
    string familyName;
|};

public type GroupsItem record {|
    string display;
    string value;
    string \$ref;
|};

public type Urn\:scim\:wso2\:schema record {|
    string userSource;
    string idpType;
    string isReadOnlyUser;
|};

public type InternsOrgUser record {|
    string[] emails;
    Meta meta;
    string[] schemas;
    RolesItem[] roles;
    Name name;
    GroupsItem[] groups;
    string id;
    string userName;
    Urn\:scim\:wso2\:schema urn\:scim\:wso2\:schema;
|};
