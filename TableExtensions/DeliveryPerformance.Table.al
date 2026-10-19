table 90002 "APSS Delivery Performance"
{
    Caption = 'Delivery Performance';
    DataClassification = CustomerContent;
    LookupPageId = "APSS Delivery Performances";
    DrillDownPageId = "APSS Delivery Performances";

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