page 90003 "APSS Delivery Timeliness List"
{
    PageType = List;
    SourceTable = "APSS Delivery Timeliness";
    Caption = 'Delivery Timeliness';
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
                    ToolTip = 'Specifies the delivery timeliness code.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the meaning of the delivery timeliness code.';
                }

                field("Counts as Delayed"; Rec."Counts as Delayed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether purchase orders with this value are counted as delayed.';
                }
            }
        }
    }
}