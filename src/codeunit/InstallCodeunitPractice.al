codeunit 60005 "Install Codeunit Practice"
{
    Subtype = Install;

    Permissions =
    tabledata "No. Series" = rimd,
    tabledata "No. Series Line" = rimd;


    trigger OnInstallAppPerCompany()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        SeriesNo: Code[20];

    begin
        SeriesNo := 'TEST';
        if not NoSeries.Get(SeriesNo) then begin

            NoSeries.Init();
            NoSeries.Validate(Code, SeriesNo);
            NoSeries.Validate(Description, 'Test Series');
            NoSeries.Insert();
        end;

        NoSeriesLine.Reset();
        NoSeriesLine.SetRange("Series Code", SeriesNo);

        if NoSeriesLine.IsEmpty() then begin
            NoSeriesLine.Init();
            NoSeriesLine.Validate("Line No.", 10000);

            NoSeriesLine.Validate("Series Code", SeriesNo);
            NoSeriesLine.Validate("Starting Date", TODAY());
            NoSeriesLine.Validate("Starting No.", SeriesNo + '1000');
            NoSeriesLine.Validate("Ending No.", SeriesNo + '9999');
            NoSeriesLine.Validate("Increment-by No.", 1);
            NoSeriesLine.Insert();
        end;
    end;
}
