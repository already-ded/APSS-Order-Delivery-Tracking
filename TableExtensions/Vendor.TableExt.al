tableextension 90001 "APSS Vendor Delivery Perf." extends Vendor
{
    fields
    {
        field(90001; "APSS Delivery Performance"; Code[20])
        {
            Caption = 'Delivery Performance';
            DataClassification = CustomerContent;
            TableRelation = "APSS Delivery Performance".Code;
            ValidateTableRelation = true;
            ToolTip = 'Specifies the vendor''s delivery performance rating.';
        }
    }
}