pageextension 60000 "Sales Quote Subform Ext" extends "Sales Quote Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Report Line No."; Rec."Sequence No. PCXP")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst("&Line")
        {
            action("MoveUp PCXP")
            {
                Caption = 'Up';
                Image = MoveUp;
                ApplicationArea = All;
                ToolTip = 'Move this line up.';
                Scope = Repeater;

                trigger OnAction()
                begin
                    Rec.MoveLine('<');
                    CurrPage.Update(false);
                end;
            }
            action("MoveDown PCXP")
            {
                Caption = 'Down';
                Image = MoveDown;
                ApplicationArea = All;
                ToolTip = 'Move this line down.';
                Scope = Repeater;

                trigger OnAction()
                begin
                    Rec.MoveLine('>');
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
