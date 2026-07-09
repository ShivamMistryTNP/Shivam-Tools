codeunit 60002 "Interface Unit Price Add" implements "Test Interface Functionality"
{

    procedure WorkOnUnitPrice(var UnitPrice: Decimal)
    begin
        UnitPrice += 10;
    end;

}
