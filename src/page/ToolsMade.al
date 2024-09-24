page 60000 "Tools Made"
{
    Caption = 'Tools Made';
    PageType = Card;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ExportOptions)
            {
                ApplicationArea = All;
                Caption = 'Export Options';
                Promoted = true;
                Image = Export;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"Exporting Options")
                end;
            }
            action(TableFields)
            {
                ApplicationArea = All;
                Caption = 'Table Fields';
                Promoted = true;
                Image = Table;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"Table Fields")
                end;
            }
            action(ImageUsage)
            {
                ApplicationArea = All;
                Caption = 'Image Usage';
                Promoted = true;
                Image = Picture;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"Image Usage")
                end;
            }
            action(FieldSelection)
            {
                ApplicationArea = All;
                Caption = 'Field Selector';
                Promoted = true;
                Image = Filter;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"Field Selector")
                end;
            }
            action(FieldFinder)
            {
                ApplicationArea = All;
                Caption = 'Field Finder';
                Promoted = true;
                Image = ViewPage;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"Field Finder")
                end;
            }
            action(TableHasFields)
            {
                ApplicationArea = All;
                Caption = 'Fields Table Finder';
                Promoted = true;
                Image = SuggestTables;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"Fields Table Finder")
                end;
            }
        }
    }
}