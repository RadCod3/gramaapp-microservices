# Description.
#
# + id - id Number  
# + Name - Name
# + genderID - Gender
#   0-Male
#   1-Female
# + accountStatusID - Acocunt status
#   0 -Active
#   1 - Suspended
public type Citizen record {|
    string id;
    string Name;
    int genderID;
    int accountStatusID;
|};