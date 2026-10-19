table 90005 "APSS PO Delay Reason"
{
    Caption = 'Purchase Order Delay Reason';
    DataClassification = CustomerContent;
    LookupPageId = "APSS PO Delay Reasons";
    DrillDownPageId = "APSS PO Delay Reasons";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {
        }

        fieldgroup(Brick; Code, Description)
        {
        }
    }
}