table 60002 "Dynamic List Table"
{
    Caption = 'Dynamic List Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Dynamic Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Dynamic Code")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        PurchHeader: Record "Purchase Header";
        ErrorLabel: Label 'Can not delete %1 due to being currently used in Purchase Orders';
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Dynamic Code", Rec."Dynamic Code");
        if not PurchHeader.IsEmpty then
            Error(ErrorLabel, "Dynamic Code");



    end;
}
