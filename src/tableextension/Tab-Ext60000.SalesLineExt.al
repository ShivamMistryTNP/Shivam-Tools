tableextension 60000 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50000; "Printing Order Line No."; Integer)
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
        OriginalSeq := Rec."Printing Order Line No.";
        // OriginalItem := Rec."Item PCXP";
        SalesLine.SetCurrentKey("Printing Order Line No.");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        SalesLine.SetRange("Document Type", REc."Document Type");
        SalesLine.SetRange("Line No.", REc."Line No.");
        if not SalesLine.FindFirst() then
            exit;
        // FindNextLine(Rec."Line No.", Direction);
        SalesLine.SetRange("Line No.");
        if SalesLine.Find(Direction) then begin
            SwapSeq := SalesLine."Printing Order Line No.";
            // SwapItem := SalesLine."Item PCXP";
            SalesLine."Printing Order Line No." := OriginalSeq;
            Rec."Printing Order Line No." := SwapSeq;
            // if (SwapItem <> 0) and (OriginalItem <> 0) then begin
            // Rec."Item PCXP" := SwapItem;
            // SalesLine."Item PCXP" := OriginalItem;
            // end;
            SalesLine.Modify(true);
            Rec.Modify(true);

            // ReOrderLines(Rec)
        end;
    end;

    local procedure AssignLineNo()
    begin
        if (Rec."Printing Order Line No." = 0) then
            "Printing Order Line No." := "Line No.";
    end;
}
