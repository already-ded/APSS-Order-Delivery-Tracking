page 90005 "APSS PO Delay Reasons"
{
    PageType = List;
    SourceTable = "APSS PO Delay Reason";
    Caption = 'Purchase Order Delay Reasons';
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
                    ToolTip = 'Specifies the delay reason code.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the delay reason.';
                }
            }
        }
    }
}