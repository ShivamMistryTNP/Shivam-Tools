table 60000 "Own Fields"
{
    Caption = 'Own Fields';
    DataClassification = ToBeClassified;
    TableType = Temporary;
    fields
    {
        field(1; TableNo; Integer)
        {
        }
        field(2; "No."; Integer)
        {
        }
        field(3; TableName; Text[30])
        {
        }
        field(4; FieldName; Text[30])
        {
        }
        field(5; Type; Text[30])
        {
        }
        field(6; "Type Name"; Text[30])
        {
        }
        field(7; "Field Caption"; Text[80])
        {
        }
        field(8; "Use Field"; Boolean)
        {
            Caption = 'Use Field';
            DataClassification = ToBeClassified;
        }
        field(9; "Number Order"; Integer)
        {
            Caption = 'Number Order';
            DataClassification = ToBeClassified;

        }
    }
    keys
    {
        key(pk; TableNo, "No.")
        {
        }
    }
}
