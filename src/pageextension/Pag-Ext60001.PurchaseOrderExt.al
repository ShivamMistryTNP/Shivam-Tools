pageextension 60001 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter("Document Date")
        {
            field("Dynamic Code"; Rec."Dynamic Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dynamic Code field.', Comment = '%';
            }
        }
    }
}
