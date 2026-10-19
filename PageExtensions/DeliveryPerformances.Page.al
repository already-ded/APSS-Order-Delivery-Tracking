page 90002 "APSS Delivery Performances"
{
    PageType = List;
    SourceTable = "APSS Delivery Performance";
    Caption = 'Delivery Performances';
    ApplicationArea = All;
    UsageCategory = Lists;

    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the delivery performance code.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the delivery performance rating.';
                }
            }
        }
    }
}