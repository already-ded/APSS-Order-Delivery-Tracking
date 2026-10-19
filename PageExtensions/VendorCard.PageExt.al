pageextension 90001 "APSS Vendor Card Del. Perf." extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("APSS Delivery Performance"; Rec."APSS Delivery Performance")
            {
                ApplicationArea = All;
            }
        }
    }
}
