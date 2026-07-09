codeunit 60003 "Interface Unit Price Minus" implements "Test Interface Functionality"
{
    procedure WorkOnUnitPrice(var UnitPrice: Decimal)
    begin
        UnitPrice -= 10;
    end;
}
