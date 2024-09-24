table 60001 "Own Table Information"
{
    Caption = 'Own Table Information';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table No."; Integer)
        {
        }
        field(2; "Name of Table"; Text[30])
        {
        }

    }
    keys
    {
        key(PK; "Table No.")
        {
            Clustered = true;
        }
    }
}
