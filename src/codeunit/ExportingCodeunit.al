codeunit 60000 "Exporting Codeunit"
{
    //Exporting as JSON Start.
    procedure ExportTableAsJSONFile(JSONObjName: Text; JSONObjFileName: Text; RecordRefPassed: RecordRef)
    var
        TempBlob: Codeunit "Temp Blob";
        InputStream: InStream;
        OutputStream: OutStream;
        JsonObj: JsonObject;
        Name: Text;

        NewJSONObjNameNoSpaces: Text;
    begin
        FieldCount := RecordRefPassed.FieldCount;
        NewJSONObjNameNoSpaces := DelChr(JSONObjName, '=', ' ');

        JsonObj.Add(NewJSONObjNameNoSpaces, ExportJSONArray(RecordRefPassed));
        TempBlob.CreateOutStream(OutputStream);
        JsonObj.WriteTo(OutputStream);

        TempBlob.CreateInStream(InputStream);
        Name := NewJSONObjNameNoSpaces + '.json';
        DownloadFromStream(InputStream, JSONObjFileName, '', '', Name);
        // Message('JSON File Extracted: %1', JSONObjName);
    end;

    local procedure ExportJSONArray(RecordRefPassed: RecordRef): JsonArray
    var
        JSONArrayVar: JsonArray;
    begin
        if RecordRefPassed.FindSet() then
            repeat
                JSONArrayVar.add(ExportSingleRecordData(RecordRefPassed));
            until RecordRefPassed.Next() = 0;
        exit(JSONArrayVar);
    end;

    local procedure ExportSingleRecordData(RecordRefPassed: RecordRef): JsonObject
    var
        JSONSingleRecord: JsonObject;
        StartIndex: Integer;
        valueText: Text;
    begin

        for StartIndex := 1 to FieldCount do begin
            JSONSingleRecord.Add(RecordRefPassed.FieldIndex(StartIndex).Name, Format(RecordRefPassed.FieldIndex(StartIndex).Value));
        end;
        exit(JSONSingleRecord);
    end;
    //Exporting as JSON End.

    //Exporting as TAB Start.
    procedure ExportTableAsTABfile(TABObjName: Text; TABObjFileName: Text; RecordRefPassed: RecordRef; FileType: Text)
    var
        InputStream: InStream;
        Name: Text;
        NewTABObjNameNoSpaces: Text;
    begin
        GlobalFileType := FileType;
        Tab[1] := 9;
        FieldCount := RecordRefPassed.FieldCount;
        NewTABObjNameNoSpaces := DelChr(TABObjName, '=', ' ');

        TempBlob.CreateOutStream(OutputStream);
        ReadThroughRecordRef(RecordRefPassed);

        OutputStream.WriteText(TextBuilderValue.ToText());
        TempBlob.CreateInStream(InputStream);

        Name := NewTABObjNameNoSpaces + '.txt';
        DownloadFromStream(InputStream, TABObjFileName, '', '', Name);
        // Message('TAB File Extracted: %1', TABObjName);
    end;

    procedure ReadThroughRecordRef(RecordRefPassed: RecordRef)
    var
        StringReceieved: Text;
    begin
        if RecordRefPassed.FindSet() then
            repeat
                if RecordValues = false then begin
                    CreateRecordStringLine(RecordRefPassed);
                    RecordValues := true;
                end;
                CreateRecordStringLine(RecordRefPassed);
            until RecordRefPassed.Next() = 0;
    end;

    procedure CreateRecordStringLine(var RecordRefPassed: RecordRef)
    var
        FieldCountIndex: Integer;
        LineString: Text;
        ValueText: Text;
    begin
        LineString := '';
        for FieldCountIndex := 1 to FieldCount do begin
            if RecordValues = false then
                LineString += RecordRefPassed.FieldIndex(FieldCountIndex).Name else
                LineString += Format(RecordRefPassed.FieldIndex(FieldCountIndex).Value);
            LineString += Format(Tab);
        end;
        TextBuilderValue.AppendLine(LineString);
    end;
    //Exporting as TAB End.

    //Exporting as CSV Start.
    procedure ExportTableAsCSVfile(CSVObjName: Text; CSVObjFileName: Text; RecordRefPassed: RecordRef; FileType: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        InputStream: InStream;
        OutputStream: OutStream;
        Name: Text;
        NewCSVObjNameNoSpaces: Text;
    begin
        GlobalFileType := FileType;
        Tab[1] := 9;
        FieldCount := RecordRefPassed.FieldCount;
        NewCSVObjNameNoSpaces := DelChr(CSVObjName, '=', ' ');
        AddDataToCSVBuffer(RecordRefPassed);
        Name := NewCSVObjNameNoSpaces + '.CSV';

        TempBlob.CreateOutStream(OutputStream);

        //This line only relates to CSV Buffer
        CSVBuffer.SaveDataToBlob(TempBlob, ',');

        TempBlob.CreateInStream(InputStream);
        DownloadFromStream(InputStream, CSVObjFileName, '', '', Name);
        // Message('CSV File Extracted: %1', CSVObjName);
    end;

    procedure AddDataToCSVBuffer(RecordRefPassed: RecordRef)
    var
        myInt: Integer;
        RecordCount: Integer;
        LineNoIndex: Integer;
        FieldNoIndex: Integer;
    begin
        FieldCount := RecordRefPassed.FieldCount();
        CSVBuffer.DeleteAll(true);
        for FieldNoIndex := 1 to FieldCount do begin
            InsertValues(LineNoIndex, FieldNoIndex, RecordRefPassed.FieldIndex(FieldNoIndex).Name); //Name of Field
        end;

        if RecordRefPassed.FindSet() then
            repeat
                RecordText := '';
                LineNoIndex := LineNoIndex + 1;
                for FieldNoIndex := 1 to FieldCount do begin
                    InsertValues(LineNoIndex, FieldNoIndex, Format(RecordRefPassed.FieldIndex(FieldNoIndex).Value));
                    RecordText += ' ' + Format(RecordRefPassed.FieldIndex(FieldNoIndex).Name) + ': ' + Format(RecordRefPassed.FieldIndex(FieldNoIndex).Value);
                end;
            until RecordRefPassed.Next() = 0;
    end;

    local procedure InsertValues(LineNoIndex: Integer; FieldNoIndex: Integer; TextValue: Text)
    var
        LineNoString: Text;
        FieldNoString: Text;
        ValueString: Text;
        TabTextValue: Text;
        TextValuePosted: Text;
    begin
        if GlobalFileType = 'CSV' then begin
            CSVBuffer.Validate("Line No.", LineNoIndex);
            CSVBuffer.Validate("Field No.", FieldNoIndex);
            CSVBuffer.Validate(Value, TextValue)
        end
        else begin
            CSVBuffer.Validate("Line No.", LineNoIndex);
            CSVBuffer.Validate("Field No.", FieldNoIndex);
            CSVBuffer.Validate(Value, Format(Tab) + TextValue)
        end;
        CSVBuffer.Insert();
    end;
    //Exporting as CSV End.

    var
        CSVBuffer: Record "CSV Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        OutputStream: OutStream;
        TextBuilderValue: TextBuilder;
        RecordValues: Boolean;
        FieldCount: Integer;
        RecordText: Text;
        GlobalFileType: Text;
        Tab: Text[1];
}
