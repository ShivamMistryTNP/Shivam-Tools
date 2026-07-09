xmlport 60001 "XMLPort Item Import"
{
    Caption = 'XMLPort Item Import';

    // If your input is CSV, include these:
    Format = VariableText;
    FieldSeparator = ',';
    TextEncoding = UTF8;
    UseRequestPage = true;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Item; Item)
            {

                fieldelement("No."; Item."No.") { }
                fieldelement(UnitPrice; Item."Unit Price") { }

                trigger OnBeforeInsertRecord()
                begin
                    // Skip blank key rows
                    if Item."No." = '' then begin
                        CurrXMLport.Skip();
                        exit;
                    end;

                    Item.Validate(Description, Item."No." + ' - ' + Format(Item."Unit Price"));
                end;

                trigger OnBeforeModifyRecord()
                begin
                    if Item."No." = '' then begin
                        CurrXMLport.Skip();
                        exit;
                    end;

                    Item.Validate(Description, Item."No." + ' - ' + Format(Item."Unit Price"));
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }
}