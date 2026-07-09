codeunit 60004 "Upgrade Codeunit Practice"
{
    Subtype = Upgrade;


    trigger OnUpgradePerCompany()
    var

        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetLoadFields("Unit Price", "Unit Price 2"); //Only loads these 2 fields instead of every field in the table
        SalesLine.SetFilter("Unit Price", '<>0');
        if SalesLine.FindSet(true, false) then
            // true  → ForUpdate Load the records ready for modification, locking them correctly for updates.
            // false → SkipLocked - Do not skip locked records. - If another user has a lock, the calling code will wait rather than skip.
            repeat
                SalesLine."Unit Price 2" := SalesLine."Unit Price" * 2;
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;
}
