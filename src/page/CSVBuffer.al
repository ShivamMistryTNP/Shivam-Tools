page 60002 "CSV Buffer"
{
    ApplicationArea = All;
    Caption = 'CSV Buffer';
    PageType = List;
    SourceTable = "CSV Buffer";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = '%';
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportCSV)
            {
                Caption = 'Import Items via CSV Buffer';
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    InsertCSVBuffer();
                end;
            }
        }
    }
    var

        CSVBuffer: Page "CSV Buffer";

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if Rec.Get(RowNo, ColNo) then
            exit(Rec.Value)
        else
            exit('');
    end;

    procedure InsertCSVBuffer()
    var
        InS: InStream;
        FileName: Text[100];
        UploadMsg: Label 'Please choose the CSV file';
        Item: Record Item;
        LineNo: Integer;
        ColNo: Integer;
        ColCount: Integer;
        LineTotal: Integer;
        ValueText: Text;

    begin
        Rec.Reset();
        Rec.DeleteAll();
        if UploadIntoStream(UploadMsg, '', '', FileName, InS) then begin
            Rec.LoadDataFromStream(InS, ',');
            ColNo := Rec.GetNumberOfColumns();
            LineTotal := Rec.GetNumberOfLines();
            for LineNo := 2 to LineTotal do begin
                for ColCount := 1 to ColNo do begin
                    Rec.Validate("Line No.", LineNo);
                    Rec.Validate("Field No.", ColNo);
                    Rec.Validate(Value, GetValueAtCell(LineNo, ColCount));
                end;
            end;
        end;
    end;

}
