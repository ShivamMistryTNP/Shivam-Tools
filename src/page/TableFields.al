page 60001 "Table Fields"
{
    ApplicationArea = All;
    Caption = 'Table Fields';
    PageType = Worksheet;
    SourceTable = "Field";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(SearchArea)
            {
                Caption = '';
                field(TableID; TableID)
                {
                    Caption = 'Table ID';
                    ToolTip = 'Search via Table ID';
                    Editable = true;
                    ApplicationArea = All;
                    TableRelation = AllObjWithCaption."Object ID" where("Object Type" = filter('Table'));
                    trigger OnValidate()
                    begin
                        FindTableInBusinessCentral();
                    end;
                }
                field(TextOutcome; TextOutcome)
                {
                    Caption = 'Outcome';
                    ToolTip = 'Shows the Outcome of Table Search';
                    ApplicationArea = All;
                    Editable = False;
                    StyleExpr = StyleExpressionText;
                }
                field(TableLookUpName; TableLookUpName)
                {
                    Caption = 'Table Name Search';
                    ToolTip = 'Search via Table Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(FieldsFoundForTableSearched; FieldsFoundForTableSearched)
                {
                    Caption = 'Fields Found';
                    ToolTip = 'Number of Fields Found';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            repeater(General)
            {
                ShowCaption = false;
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the field.';
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;
                    Caption = 'Field Name';
                    ToolTip = 'Specifies the name of the field.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                    Caption = 'Field Caption';
                    ToolTip = 'Specifies the caption of the field, that is, the name that will be shown in the user interface.';
                }
                field(Field; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Field Type';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("No.", ExtendedFieldsinBCLbl);
        TextOutcome := NoSearchUsedLbl;
        FieldsFoundForTableSearched := 0;
    end;

    local procedure FindTableInBusinessCentral()
    var
    begin
        Rec.Reset();
        AllObjWithCaption.Reset();
        TextOutcome := '';
        FieldsFoundForTableSearched := 0;
        CheckIfTableExist();
        CheckIfTableIsBCOrExtension();
        StyleExpressionText := StyleTextOutput();
        CurrPage.Update(false);
    end;

    local procedure StyleTextOutput(): Text[250];
    begin
        case TextOutcome of
            NoExtraFieldsLbl:
                exit('Ambiguous');
            FoundFieldsLbl:
                exit('Favorable');
            TableNotFoundLbl:
                exit('Unfavorable');
            NoSearchUsedLbl:
                exit('');
            NonStandardTableLbl:
                exit('StrongAccent')
        end;
    end;

    local procedure CheckIfTableExist()
    begin
        if TableID = 0 then begin
            Rec.SetFilter(TableNo, '<%1', 100000);
            TableLookUpName := '';
            TextOutcome := NoSearchUsedLbl;
        end else begin
            AllObjWithCaption.SetRange("Object ID", TableID);
            AllObjWithCaption.SetFilter("Object Type", 'Table');
            if AllObjWithCaption.FindFirst() then begin
                TableLookUpName := AllObjWithCaption."Object Caption";
                TableID := AllObjWithCaption."Object ID";
                Rec.SetFilter(TableNo, Format(TableID));
                TextOutcome := FoundFieldsLbl;
            end else begin
                Rec.SetFilter(TableNo, '%1', TableID);
                TableLookUpName := '';
                TextOutcome := TableNotFoundLbl;
            end;
        end;
    end;

    local procedure CheckIfTableIsBCOrExtension()
    begin
        if TableID >= 50000 then begin
            Rec.SetFilter("No.", '<%1', 100000);
            TextOutcome := NonStandardTableLbl;
        end else begin
            Rec.SetFilter("No.", ExtendedFieldsinBCLbl);
            if Rec.IsEmpty() then
                if AllObjWithCaption.IsEmpty() then
                    TextOutcome := TableNotFoundLbl else
                    TextOutcome := NoExtraFieldsLbl;
            FindFieldCount();
        end;
    end;

    local procedure FindFieldCount()
    begin
        if Rec.FindSet() AND (TextOutcome <> TableNotFoundLbl) AND (TableID <> 0) then
            FieldsFoundForTableSearched := Rec.Count else
            FieldsFoundForTableSearched := 0;
    end;

    var
        AllObjWithCaption: Record AllObjWithCaption;
        Field: Record Field;

        TableID: Integer;
        FieldsFoundForTableSearched: Integer;
        TableLookUpName: Text;
        TextOutcome: Text;
        StyleExpressionText: Text;
        AppName: Text;
        FieldType: Text;
        ExtendedFieldsinBCLbl: Label '50000..60000';
        FoundFieldsLbl: Label 'Table found with fields';

        TableNotFoundLbl: Label 'Table not found';
        NoExtraFieldsLbl: Label 'No extra fields';
        NoSearchUsedLbl: Label 'No Search Used';
        NonStandardTableLbl: Label 'Non Standard Table Found';

}