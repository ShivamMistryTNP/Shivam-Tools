page 60004 "Image Usage"
{
    Caption = 'Image Usage';
    UsageCategory = ReportsAndAnalysis;
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(ImageSelectOptions; ImageSelectOptions)
                {
                    Caption = 'Image Select Option';
                }
            }
        }

    }
    actions
    {
        area(Navigation)
        {
            action(InsertImage)
            {
                ApplicationArea = All;
                Caption = 'Insert Image';
                Promoted = true;
                Image = Picture;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                Enabled = ImageSelectOptions <> ImageSelectOptions::None;
                trigger OnAction()

                var
                    Image: Codeunit Image;
                    InStream: InStream;
                    Filename: Text;
                    OutStream: OutStream;
                begin
                    if UploadIntoStream('Upload Image', '', '', Filename, InStream) then begin
                        Image.FromStream(InStream);

                        //Image Data            
                        // ImageProperties(Image, InStream, Filename);

                        case ImageSelectOptions of
                            ImageSelectOptions::Properties:
                                ImageProperties(Image, InStream, Filename, OutStream);
                            ImageSelectOptions::Crop:
                                ImageCrop(Image, InStream, Filename, OutStream);
                            ImageSelectOptions::Resize:
                                ImageResize(Image, InStream, Filename, OutStream);
                            ImageSelectOptions::Rotate:
                                ImageRotate(Image, InStream, Filename, OutStream);
                            ImageSelectOptions::Format:
                                ImageFormat(Image, InStream, Filename, OutStream);
                            else
                                Error('No Image Option Selected');
                        end;
                    end;
                end;
            }
        }
    }

    local procedure ImageProperties(var Image: Codeunit Image; var InStream: InStream; var Filename: Text; OutStream: OutStream)
    var
        FirstName: Text;
        LastName: Text;
        Age: Integer;
    begin
        Message('Type %1\ Width %2\ Height %3\RotateFlipType %4', Image.GetFormat(), Image.GetHeight(), Image.GetWidth(), Image.GetRotateFlipType());

        FirstName := 'Shivam';
        LastName := 'Mistry';
        Age := 25;

        Message('First Name %1\ Last Name %2\ Age %3\ ', FirstName, LastName, Age);

        TempBlob.CreateOutStream(OutStream);
        image.Save(OutStream);
        TempBlob.CreateInStream(InStream);
        Filename := Filename.Replace('.', '2.');
        DownloadFromStream(InStream, '', '', '', Filename);
    end;

    local procedure ImageCrop(var Image: Codeunit Image; var InStream: InStream; var Filename: Text; OutStream: OutStream)
    begin
        Image.Crop(50, 50, Image.GetWidth() - 100, Image.GetHeight() - 100);

        TempBlob.CreateOutStream(OutStream);
        image.Save(OutStream);
        TempBlob.CreateInStream(InStream);
        Filename := Filename.Replace('.', '2.');
        DownloadFromStream(InStream, '', '', '', Filename);
    end;

    local procedure ImageResize(var Image: Codeunit Image; var InStream: InStream; var Filename: Text; OutStream: OutStream)
    begin
        Image.Resize(Round(image.GetWidth() * 1.5, 1), Round(image.GetHeight() * 0.8, 1));

        TempBlob.CreateOutStream(OutStream);
        image.Save(OutStream);
        TempBlob.CreateInStream(InStream);
        Filename := Filename.Replace('.', '2.');
        DownloadFromStream(InStream, '', '', '', Filename);
    end;

    local procedure ImageRotate(var Image: Codeunit Image; var InStream: InStream; var Filename: Text; OutStream: OutStream)
    begin

        Image.RotateFlip("Rotate Flip Type"::Rotate90FlipX);

        TempBlob.CreateOutStream(OutStream);
        image.Save(OutStream);
        TempBlob.CreateInStream(InStream);
        Filename := Filename.Replace('.', '2.');

        DownloadFromStream(InStream, '', '', '', Filename);
    end;

    local procedure ImageFormat(var Image: Codeunit Image; var InStream: InStream; var Filename: Text; OutStream: OutStream)
    begin
        Image.SetFormat("Image Format"::Png);

        TempBlob.CreateOutStream(OutStream);
        image.Save(OutStream);
        TempBlob.CreateInStream(InStream);
        Filename := Filename.Replace('.', '2.');
        Filename := Filename.Replace('.jpg', '.png');
        DownloadFromStream(InStream, '', '', '', Filename);
    end;

    var
        TempBlob: Codeunit "Temp Blob";
        ImageSelectOptions: Enum "Image Select Options";
}
