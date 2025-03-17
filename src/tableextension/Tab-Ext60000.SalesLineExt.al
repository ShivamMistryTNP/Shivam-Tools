tableextension 60000 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50000; "Sequence No. PCXP"; Integer)
        {
            Caption = 'Report Line No';
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(50001; "Item PCXP"; Integer)
        {
            Caption = 'Report Line No';
            DataClassification = CustomerContent;
            Editable = False;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                AssignLineNo();
            end;
        }
        modify(Description)
        {
            trigger OnAfterValidate()
            begin
                AssignLineNo();
            end;
        }
    }
    trigger OnBeforeInsert()
    begin
        AssignLineNo();
    end;

    procedure MoveLine(Direction: Text)
    var
        SalesLine: Record "Sales Line";
        OriginalSeq: Integer;
        SwapSeq: Integer;
        OriginalItem: Decimal;
        SwapItem: Decimal;
    begin
        OriginalSeq := Rec."Sequence No. PCXP";
        OriginalItem := Rec."Item PCXP";
        SalesLine.SetCurrentKey("Sequence No. PCXP");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        SalesLine.SetRange("Document Type", REc."Document Type");
        SalesLine.SetRange("Line No.", REc."Line No.");
        if not SalesLine.FindFirst() then
            exit;
        // FindNextLine(Rec."Line No.", Direction);
        SalesLine.SetRange("Line No.");
        if SalesLine.Find(Direction) then begin
            SwapSeq := SalesLine."Sequence No. PCXP";
            SwapItem := SalesLine."Item PCXP";
            SalesLine."Sequence No. PCXP" := OriginalSeq;
            Rec."Sequence No. PCXP" := SwapSeq;
            if (SwapItem <> 0) and (OriginalItem <> 0) then begin
                Rec."Item PCXP" := SwapItem;
                SalesLine."Item PCXP" := OriginalItem;
            end;
            SalesLine.Modify(true);
            Rec.Modify(true);

            // ReOrderLines(Rec)
        end;
    end;

    local procedure AssignLineNo()
    begin
        if (Rec."Sequence No. PCXP" = 0) then
            "Sequence No. PCXP" := "Line No.";
    end;
}
