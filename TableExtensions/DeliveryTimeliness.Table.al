table 90004 "APSS Delivery Timeliness"
{
    Caption = 'Delivery Timeliness';
    DataClassification = CustomerContent;
    LookupPageId = "APSS Delivery Timeliness List";
    DrillDownPageId = "APSS Delivery Timeliness List";

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
        field(3; "Counts as Delayed"; Boolean)
        {
            Caption = 'Counts as Delayed';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether this timeliness value represents a delayed delivery.';
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