page 60005 "Field Selector"
{
    Caption = 'Field Selector';
    PageType = Worksheet;
    UsageCategory = Lists;
    SourceTable = "Own Fields";
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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the field.';
                    Editable = false;
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;
                    Caption = 'Field Name';
                    ToolTip = 'Specifies the name of the field.';
                    Editable = false;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                    Caption = 'Field Caption';
                    ToolTip = 'Specifies the caption of the field, that is, the name that will be shown in the user interface.';
                    Editable = false;
                }
                field(Field; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Field Type';
                    Editable = false;
                }
                field(FieldNumberOrder; Rec."Number Order")
                {
                    ApplicationArea = All;
                    Caption = 'Order';
                    Editable = TableID <> 0;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        OwnFieldsCheck: Record "Own Fields";
                    begin
                        CanUseAction := CheckIfAnyValuesAreNotZero();

                        if Rec."Number Order" = 0 then begin
                            Rec."Use Field" := false;
                            exit;
                        end;
                        Rec.Reset();
                        Rec.SetRange("Number Order", Rec."Number Order");
                        if Rec.Count() > 0 then
                            Error('Another record has the Number Order: %1', Rec."Number Order") else
                            Rec."Use Field" := true;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(AnnounceOrder)
            {
                ApplicationArea = All;
                Caption = 'Announce Order';
                Promoted = true;
                Image = Export;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Enabled = CanUseAction;
                trigger OnAction()
                begin
                    AnnouceOrderOfFields();
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Field.SetFilter("No.", AnyFieldsinBCLbl);
        TextOutcome := NoSearchUsedLbl;
        FieldsFoundForTableSearched := 0;
    end;

    local procedure FindTableInBusinessCentral()
    begin
        Field.Reset();
        AllObjWithCaption.Reset();
        TextOutcome := '';
        FieldsFoundForTableSearched := 0;
        CheckIfTableExist();
        CheckIfTableIsBCOrExtension();
        InsertFields(Rec);
        StyleExpressionText := StyleTextOutput();
        Rec.Reset();
        Rec.SetCurrentKey("No.");
        Rec.Ascending(true);
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
            Field.SetFilter(TableNo, '<%1', 100000);
            TableLookUpName := '';
            TextOutcome := NoSearchUsedLbl;
        end else begin
            AllObjWithCaption.SetRange("Object ID", TableID);
            AllObjWithCaption.SetFilter("Object Type", 'Table');
            if AllObjWithCaption.FindFirst() then begin
                TableLookUpName := AllObjWithCaption."Object Caption";
                TableID := AllObjWithCaption."Object ID";
                Field.SetFilter(TableNo, Format(TableID));
                TextOutcome := FoundFieldsLbl;
            end else begin
                Field.SetFilter(TableNo, '%1', TableID);
                TableLookUpName := '';
                TextOutcome := TableNotFoundLbl;
            end;
        end;
    end;

    local procedure CheckIfTableIsBCOrExtension()
    begin
        if TableID >= 50000 then begin
            Field.SetFilter("No.", '<%1', 100000);
            TextOutcome := NonStandardTableLbl;
        end else begin
            Field.SetFilter("No.", AnyFieldsinBCLbl);
            if Field.IsEmpty() then
                if AllObjWithCaption.IsEmpty() then
                    TextOutcome := TableNotFoundLbl else
                    TextOutcome := NoExtraFieldsLbl;
            FindFieldCount();
        end;
    end;

    local procedure FindFieldCount()
    begin
        if Field.FindSet() AND (TextOutcome <> TableNotFoundLbl) AND (TableID <> 0) then
            FieldsFoundForTableSearched := Field.Count else
            FieldsFoundForTableSearched := 0;
    end;

    local procedure InsertFields(var Record: Record "Own Fields" temporary)
    begin
        Record.DeleteAll();
        Record.Reset();
        if Field.FindSet() then
            repeat
                Record.Validate(TableNo, Field.TableNo);
                Record.Validate("No.", Field."No.");
                Record.Validate(TableName, Field.TableName);
                Record.Validate(FieldName, Field.FieldName);
                Record.Validate("Type Name", Field."Type Name");
                Record.Validate(Type, Format(Field.Type));
                Record.Validate("Field Caption", Field."Field Caption");
                Record.Validate("Use Field", false);
                Record.Validate("Number Order", 0);
                Record.Insert(false);
            until Field.Next() = 0;
    end;

    local procedure AnnouceOrderOfFields()
    begin
        Rec.Reset();
        Rec.SetCurrentKey("Number Order");
        Rec.Ascending(true);
    end;

    local procedure CheckIfAnyValuesAreNotZero(): Boolean
    var
    begin
        Rec.Reset();
        Rec.SetFilter("Number Order", '<>%1', 0);
        if Rec.IsEmpty then
            exit(false)
        else
            exit(true)
    end;

    var
        AllObjWithCaption: Record AllObjWithCaption;
        Field: Record Field;

        TableID: Integer;
        FieldsFoundForTableSearched: Integer;
        TableLookUpName: Text;
        TextOutcome: Text;
        StyleExpressionText: Text;
        AnyFieldsinBCLbl: Label '1..99999';

        FoundFieldsLbl: Label 'Table found with fields';

        TableNotFoundLbl: Label 'Table not found';
        NoExtraFieldsLbl: Label 'No extra fields';
        NoSearchUsedLbl: Label 'No Search Used';
        NonStandardTableLbl: Label 'Non Standard Table Found';
        CanUseAction: Boolean;
}