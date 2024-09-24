page 60008 "Fields Table Finder"
{
    ApplicationArea = All;
    Caption = 'Fields Table Finder';
    PageType = Worksheet;
    SourceTable = "Own Table Information";
    UsageCategory = Lists;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(SearchArea)
            {
                Caption = '';
                field(FieldFinderInput1; FieldFinderInput1)
                {
                    Caption = 'Field Finder Search 1';
                    ToolTip = 'Search what Table the field is in';
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Size1 := GetSize(FieldFinderInput1, ListOfTables1);
                        CheckIfActionIsEnabled();
                        CurrPage.Update(false);
                    end;
                }

                field(FieldFinderInput2; FieldFinderInput2)
                {
                    Caption = 'Field Finder Search 2';
                    ToolTip = 'Search what Table the field is in';
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Size2 := GetSize(FieldFinderInput2, ListOfTables2);
                        CheckIfActionIsEnabled();
                        CurrPage.Update(false);
                    end;
                }

                field(FieldFinderInput3; FieldFinderInput3)
                {
                    Caption = 'Field Finder Search 3';
                    ToolTip = 'Search what Table the field is in';
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Size3 := GetSize(FieldFinderInput3, ListOfTables3);
                        CheckIfActionIsEnabled();
                        CurrPage.Update(false);
                    end;
                }
                field(CaptionOrFieldName; CaptionOrFieldName)
                {
                    Caption = 'Caption or Field Name';
                    ToolTip = 'Search Caption or Field Name';
                    Editable = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Size1 := GetSize(FieldFinderInput1, ListOfTables1);
                        Size2 := GetSize(FieldFinderInput2, ListOfTables2);
                        Size3 := GetSize(FieldFinderInput3, ListOfTables3);
                        CheckIfActionIsEnabled();
                        CurrPage.Update(false);
                    end;
                }
                field(Size1; Size1)
                {
                    Caption = 'Size 1';
                    Editable = False;
                    ApplicationArea = All;
                }
                field(Size2; Size2)
                {
                    Caption = 'Size 2';
                    Editable = False;
                    ApplicationArea = All;
                }
                field(Size3; Size3)
                {
                    Caption = 'Size 3';
                    Editable = False;
                    ApplicationArea = All;
                }
                field(TableFoundCount; TableFoundCount)
                {
                    Caption = 'Table Count';
                    ToolTip = 'Shows the number of Tables found';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            repeater(General)
            {
                ShowCaption = false;
                Editable = false;
                field(TableName; Rec."Name of Table")
                {
                    ApplicationArea = All;
                    Caption = 'Table Name';
                    ToolTip = 'Specifies the name of the table.';
                }
                field(TableNo; Rec."Table No.")
                {
                    ApplicationArea = All;
                    Caption = 'Table No.';
                    ToolTip = 'Specifies the table number.';
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action(FindLowestList)
            {
                ApplicationArea = All;
                Caption = 'Search';
                Promoted = true;
                Image = SuggestTables;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Enabled = CanUseAction;
                trigger OnAction()
                begin
                    Rec.DeleteAll();
                    ClearList(ListOfTablesAlreadyDone);
                    TableFoundCount := 0;
                    FindLowest();
                end;
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
        FieldsFoundForTableSearched := 0;

        ClearList(ListOfTables1);
        ClearList(ListOfTables2);
        ClearList(ListOfTables3);

        SearchForFields(FieldFinderInput1, ListOfTables1);
        SearchForFields(FieldFinderInput2, ListOfTables2);
        SearchForFields(FieldFinderInput3, ListOfTables3);

        CurrPage.Update(false);
    end;

    local procedure FindFieldCount()
    begin
        if Rec.FindSet() then
            FieldsFoundForTableSearched := Rec.Count else
            FieldsFoundForTableSearched := 0;
    end;

    local procedure SearchForFields(FieldFinderInput: Text; ListOfTables: List of [Integer]): Integer
    var
        myInt: Integer;
        FieldTable: Record Field;
    begin
        FieldTable.Reset();
        if FieldFinderInput <> '' then begin
            TextFinderFiltered := '*' + FieldFinderInput + '*';
            if CaptionOrFieldName = true then
                FieldTable.SetFilter(FieldName, TextFinderFiltered)
            else
                FieldTable.SetFilter("Field Caption", TextFinderFiltered);
            if FieldTable.FindSet() then
                repeat
                    ListOfTables.Add(FieldTable.TableNo);
                until FieldTable.Next() = 0;
        end;
    end;

    local procedure GetSize(FieldFinderInput: Text; ListOfTables: List of [Integer]): Integer
    var
        myInt: Integer;
        FieldTable: Record Field;
        Value: Integer;
    begin
        FieldTable.Reset();
        if FieldFinderInput <> '' then begin
            TextFinderFiltered := '*' + FieldFinderInput + '*';
            if CaptionOrFieldName = true then
                FieldTable.SetFilter(FieldName, TextFinderFiltered)
            else
                FieldTable.SetFilter("Field Caption", TextFinderFiltered);
            if FieldTable.FindSet() then
                Value := FieldTable.Count
            else
                Value := 0;
            exit(Value);
        end;
    end;

    local procedure UseListTable(ListOfTables: List of [Integer]; FindLowestList: Integer)
    var
        i: Integer;
        CurrentValue: Integer;
        Value1: Boolean;
        Value2: Boolean;
        Value3: Boolean;
        Total: Text;
    begin
        Total := '';

        ClearList(ListOfTables1);
        ClearList(ListOfTables2);
        ClearList(ListOfTables3);

        SearchForFields(FieldFinderInput1, ListOfTables1);
        SearchForFields(FieldFinderInput2, ListOfTables2);
        SearchForFields(FieldFinderInput3, ListOfTables3);

        CurrentValue := ListOfTables.Count;

        for i := 1 to ListOfTables.Count do begin
            Value1 := ListOfTables1.Contains(ListOfTables.Get(i));
            value2 := ListOfTables2.Contains(ListOfTables.Get(i));
            Value3 := ListOfTables3.Contains(ListOfTables.Get(i));
            if (ListOfTables1.Count > 0) AND (ListOfTables2.Count > 0) AND (ListOfTables3.Count > 0) then begin
                if (Value1 = true) AND (Value2 = true) AND (Value3 = true) then begin
                    AddCurrentTable := ListOfTables.Get(i);
                    Total := Total + Format(AddCurrentTable);
                    if i <> ListOfTables.Count then
                        Total := Total + '|';
                    SearchForTable(AddCurrentTable);
                end;
            end else
                if (ListOfTables1.Count > 0) AND (ListOfTables2.Count > 0) AND (ListOfTables3.Count = 0) then begin
                    if Value1 = true AND Value2 = true then begin
                        AddCurrentTable := ListOfTables.Get(i);
                        Total := Total + Format(AddCurrentTable);
                        if i <> ListOfTables.Count then
                            Total := Total + '|';
                        SearchForTable(AddCurrentTable);
                    end;
                end else
                    if (ListOfTables1.Count > 0) AND (ListOfTables2.Count = 0) AND (ListOfTables3.Count > 0) then begin
                        if Value1 = true AND Value3 = true then begin
                            AddCurrentTable := ListOfTables.Get(i);
                            Total := Total + Format(AddCurrentTable);
                            if i <> ListOfTables.Count then
                                Total := Total + '|';
                            SearchForTable(AddCurrentTable);
                        end;
                    end else
                        if (ListOfTables1.Count = 0) AND (ListOfTables2.Count > 0) AND (ListOfTables3.Count > 0) then
                            if Value2 = true AND Value3 = true then begin
                                AddCurrentTable := ListOfTables.Get(i);
                                Total := Total + Format(AddCurrentTable);
                                if i <> ListOfTables.Count then
                                    Total := Total + '|';
                                SearchForTable(AddCurrentTable);
                            end;
        end;
        TableFoundCount := Rec.Count;
        CurrPage.Update(false);
    end;

    local procedure FindLowest()
    var
        ListOfTablesA: List of [Integer];
    begin
        if (Size1 > 0) AND (Size2 > 0) AND (Size3 > 0) then begin
            if Size1 < Size2 then
                if Size1 < Size3 then
                    FindLowestList := 1
                else
                    FindLowestList := 3
            else
                if Size2 < Size3 then
                    FindLowestList := 2
                else
                    FindLowestList := 3;
        end else
            if (Size1 > 0) AND (Size2 > 0) AND (Size3 = 0) then begin
                if Size1 < Size2 then
                    FindLowestList := 1
                else
                    FindLowestList := 2;
            end else
                if (Size1 > 0) AND (Size2 = 0) AND (Size3 > 0) then begin
                    if Size1 < Size3 then
                        FindLowestList := 1
                    else
                        FindLowestList := 3;
                end else
                    if (Size1 = 0) AND (Size2 > 0) AND (Size3 > 0) then begin
                        if Size2 < Size3 then
                            FindLowestList := 2
                        else
                            FindLowestList := 3;
                    end else
                        FindLowestList := 0;
        if FindLowestList > 0 then begin
            case FindLowestList of
                1:
                    begin
                        SearchForFields(FieldFinderInput1, ListOfTablesA);
                        UseListTable(ListOfTablesA, FindLowestList);
                    end;
                2:
                    begin
                        SearchForFields(FieldFinderInput2, ListOfTablesA);
                        UseListTable(ListOfTablesA, FindLowestList);
                    end;
                3:
                    begin
                        SearchForFields(FieldFinderInput3, ListOfTablesA);
                        UseListTable(ListOfTablesA, FindLowestList);
                    end;
                else
                    ;
            end;
        end
    end;

    local procedure SearchForTable(TableID: Integer)
    begin
        if ListOfTablesAlreadyDone.Contains(TableID) then
            exit;
        ListOfTablesAlreadyDone.Add(TableID);
        Rec.Reset();
        Rec.Validate(Rec."Table No.", TableID);
        Rec.Validate("Name of Table", OutputTableName(TableID));
        Rec.Insert();
    end;

    local procedure OutputTableNo(var Get: Integer): Integer
    var
        myInt: Integer;
    begin
        FieldRecord.Reset();
        FieldRecord.SetRange(TableNo, Get);
        if FieldRecord.FindFirst() then
            myInt := FieldRecord.TableNo;
        exit(myInt);
    end;

    local procedure OutputTableName(var Get: Integer): Text
    var
        Name: Text;
    begin
        FieldRecord.Reset();
        FieldRecord.SetRange(TableNo, Get);
        if FieldRecord.FindFirst() then
            Name := FieldRecord.TableName;
        exit(Name);
    end;

    local procedure ClearList(var List: List of [Integer])
    begin
        List.RemoveRange(1, List.Count);
    end;

    local procedure CheckIfActionIsEnabled()
    var
        myInt: Integer;
    begin
        myInt := 0;
        if Size1 > 0 then
            myInt += 1;
        if Size2 > 0 then
            myInt += 1;
        if Size3 > 0 then
            myInt += 1;
        if myInt > 1 then
            CanUseAction := true else
            CanUseAction := false;
    end;

    var
        FieldRecord: Record Field;
        TextFinderFiltered: Text;
        FieldsFoundForTableSearched: Integer;
        FieldFinderInput1, FieldFinderInput2, FieldFinderInput3 : Text;
        ListOfTables1, ListOfTables2, ListOfTables3 : List of [Integer];
        Size1, Size2, Size3 : Integer;
        ListOfTablesAlreadyDone: List of [Integer];
        AddCurrentTable: Integer;
        TableFoundCount: Integer;
        CanUseAction, CaptionOrFieldName : Boolean;

        FindLowestList: Integer;
}