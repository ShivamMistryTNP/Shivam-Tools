page 60007 "Field Finder"
{
    ApplicationArea = All;
    Caption = 'Field Finder';
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
                field(FieldFinderInput; FieldFinderInput)
                {
                    Caption = 'Field Finder Search';
                    ToolTip = 'Search what Table the field is in';
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        FindFieldsInBusinessCentral()
                    end;
                }
                field(FieldsFoundForTableSearched; FieldsFoundForTableSearched)
                {
                    Caption = 'Fields Found';
                    ToolTip = 'Number of Fields Found';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CaptionOrFieldName; CaptionOrFieldName)
                {
                    Caption = 'Caption or Field Name';
                    ToolTip = 'Search Caption or Field Name';
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        FindFieldsInBusinessCentral()
                    end;
                }
            }
            repeater(General)
            {
                ShowCaption = false;
                Editable = false;
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                    Caption = 'Table Name';
                    ToolTip = 'Specifies the name of the table.';
                }
                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = All;
                    Caption = 'Table No.';
                    ToolTip = 'Specifies the table number.';
                }
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
        FieldsFoundForTableSearched := 0;
    end;

    local procedure FindFieldsInBusinessCentral()
    var
    begin
        Rec.Reset();
        AllObjWithCaption.Reset();
        FieldsFoundForTableSearched := 0;
        SearchForFields();
        FindFieldCount();
        CurrPage.Update(false);
    end;

    local procedure FindFieldCount()
    begin
        if Rec.FindSet() then
            FieldsFoundForTableSearched := Rec.Count else
            FieldsFoundForTableSearched := 0;
    end;

    local procedure SearchForFields()
    var
        myInt: Integer;
    begin
        Rec.Reset();
        if FieldFinderInput <> '' then begin
            TextFinderFiltered := '*' + FieldFinderInput + '*';
            if CaptionOrFieldName = true then
                Rec.SetFilter(FieldName, TextFinderFiltered)
            else
                Rec.SetFilter("Field Caption", TextFinderFiltered);
        end;
    end;

    var
        AllObjWithCaption: Record AllObjWithCaption;
        TextFinderFiltered: Text;
        FieldFinderInput: Text;
        FieldsFoundForTableSearched: Integer;
        CaptionOrFieldName: Boolean;
}