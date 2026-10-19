tableextension 90003 "APSS Purch. Header Timing" extends "Purchase Header"
{
    fields
    {
        field(90003; "APSS Delivery Timeliness"; Code[20])
        {
            Caption = 'Delivery Timeliness';
            DataClassification = CustomerContent;
            TableRelation = "APSS Delivery Timeliness".Code;
            ValidateTableRelation = true;
            ToolTip = 'Specifies whether the purchase order delivery is early, on time, late, or another user-defined value.';
        }

        field(90004; "APSS Delay Reason Code"; Code[20])
        {
            Caption = 'Delay Reason';
            DataClassification = CustomerContent;
            TableRelation = "APSS PO Delay Reason".Code;
            ValidateTableRelation = true;
            ToolTip = 'Specifies the reason for the purchase order delay.';
        }

        field(90005; "APSS Delay Explanation"; Text[500])
        {
            Caption = 'Delay Explanation';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies additional details or comments about the purchase order delay.';
        }
    }
}