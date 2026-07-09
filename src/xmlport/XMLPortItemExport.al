xmlport 60000 "XMLPort Item Export"
{
    Direction = Export;
    Format = VariableText;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '<NewLine>';//New line



    schema
    {

        textelement(RootNodeName)
        {
            tableelement(Integer; Integer)
            {

                XmlName = 'ItemHeader';
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(ItemNoTitle)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemNoTitle := Item.FieldCaption("No.");
                    end;
                }
                textelement(ItemDescTitle)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemDescTitle := Item.FieldCaption(Description);
                    end;
                }
                textelement(ItemUnitPrice)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ItemUnitPrice := Item.FieldCaption("Unit Price");
                    end;
                }

            }
            tableelement(Item; Item)
            {
                fieldelement("No."; Item."No.")
                {
                }
                fieldelement(Description; Item.Description)
                {
                }
                fieldelement(UnitPrice; Item."Unit Price")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
