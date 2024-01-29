# Description.
#
# + UserID - field description  
# + NIC - id Number  
# + Name - Name  
# + genderID - Gender  
# 0-Male  
# 1-Female  
# + accountStatusID - Acocunt status  
# 0 -Active  
# 1 - Suspended  
# + gramaID - field description
public type Citizen record {|
    string UserID;
    string NIC;
    string Name;
    int genderID;
    int accountStatusID;
    string gramaID;
|};