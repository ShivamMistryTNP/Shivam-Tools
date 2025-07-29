tableextension 60001 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(60000; "Dynamic Code"; Code[20])
        {
            Caption = 'Dynamic Code';
            DataClassification = ToBeClassified;
        }
    }
}
