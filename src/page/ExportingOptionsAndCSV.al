page 60003 "Exporting Options"
{
    Caption = 'Exporting Options';
    PageType = Card;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "CSV Buffer";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TableIDVariable; TableID)
                {
                    ApplicationArea = All;
                    Caption = 'Table ID';
                    TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table), "Object ID" = FILTER(.. 1260 | 1262 .. 99999999 | 2000000004 | 2000000005));

                    trigger OnValidate()
                    var
                        RecRef: RecordRef;
                        AllObjWithCaption: Record AllObjWithCaption;
                        TableIDNotExistLbl: Label 'Table ID %1 does not exist';
                    begin
                        if TableID = 0 then begin
                            RecordName := '';
                            exit;
                        end;
                        AllObjWithCaption.Reset();
                        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
                        AllObjWithCaption.SetRange("Object ID", TableID);
                        if AllObjWithCaption.IsEmpty then
                            Error(TableIDNotExistLbl, TableID);
                        RecRef.Open(TableID);
                        RecordName := RecRef.Caption;
                    end;
                }
                field(RecordNameVariable; RecordName)
                {
                    ApplicationArea = All;
                    Caption = 'Record Name';
                    Editable = false;
                }
            }
            repeater(CSVBuffer)
            {
                Caption = 'CSV Buffer';
                field(CSVBufferLineNo; Rec."Line No.")
                {

                }
                field(CSVBufferFieldNo; Rec."Field No.")
                {

                }
                field(CSVBufferValue; Rec.Value)
                {

                }

            }
        }

    }
    actions
    {
        area(Navigation)
        {
            action(GetFieldName)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;
                PromotedOnly = true;
                Caption = 'Export Table as JSON File';
                Enabled = TableID <> 0;
                trigger OnAction()
                var
                    RecRef: RecordRef;
                    FieldCount: Integer;
                    StartIndex: Integer;
                    FileName: Text;
                begin
                    RecRef.Open(TableID);
                    FileName := RecordName + ' JSON Export';
                    ExportingCodeunit.ExportTableAsJSONFile(RecordName, FileName, RecRef);

                end;
            }
            action(ConvertTabletoCSV)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;
                Caption = 'Export Table as CSV File';
                Enabled = TableID <> 0;
                trigger OnAction()
                var
                    RecRef: RecordRef;
                    FieldCount: Integer;
                    StartIndex: Integer;
                    FileName: Text;
                begin
                    RecRef.Open(TableID);
                    FileName := RecordName + ' CSV';
                    ExportingCodeunit.ExportTableAsCSVfile(RecRef.Name, FileName, RecRef, 'CSV');
                end;
            }
            action(ConvertTabletoTxt)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;
                Enabled = TableID <> 0;
                trigger OnAction()
                var
                    RecRef: RecordRef;
                    FieldCount: Integer;
                    StartIndex: Integer;
                    FileName: Text;
                begin
                    RecRef.Open(TableID);
                    FileName := RecordName + ' TAB';
                    ExportingCodeunit.ExportTableAsTABfile(RecRef.Name, FileName, RecRef, 'txt');
                end;
            }
            action(ImportCSV)
            {
                Caption = 'Import CSV Buffer';
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CSVBufferPage: Page "CSV Buffer";
                    CSVBuffer: Record "CSV Buffer";
                begin
                    InsertCSVBuffer();
                end;
            }
        }
    }

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

    procedure GetJsonTextField(JsonObj: JsonObject; MemberText: Text): Text
    var
        JsonTokenResult: JsonToken;
        TextGot: Text;
    begin
        if JsonObj.Get(MemberText, JsonTokenResult) then begin
            exit(JsonTokenResult.AsValue().AsText());
        end;

    end;


    var
        CSVBuffer: Record "CSV Buffer" temporary;
        TableID: Integer;
        RecordName: Text;
        ExportingCodeunit: Codeunit "Exporting Codeunit";
}

