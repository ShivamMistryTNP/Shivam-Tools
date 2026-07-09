enum 60001 "Interface Unit Price" implements "Test Interface Functionality"
{
    Extensible = true;
    value(0; InterfaceUnitPriceAdd)
    {
        Caption = 'Unit Price Add';
        Implementation = "Test Interface Functionality" = "Interface Unit Price Add";
    }
    value(1; InterfaceUnitPriceMinus)
    {
        Caption = 'Unit Price Minus';
        Implementation = "Test Interface Functionality" = "Interface Unit Price Minus";
    }
}
