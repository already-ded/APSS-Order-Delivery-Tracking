permissionset 90000 "APSS VEND PURCH RATE"
{
    Assignable = true;
    Caption = 'APSS Vendor and Purchase Rating';

    Permissions =
        table "APSS Delivery Performance" = X,
        tabledata "APSS Delivery Performance" = RIMD,
        page "APSS Delivery Performances" = X,
        table "APSS Delivery Timeliness" = X,
        tabledata "APSS Delivery Timeliness" = RIMD,
        page "APSS Delivery Timeliness List" = X,
        table "APSS PO Delay Reason" = X,
        tabledata "APSS PO Delay Reason" = RIMD,
        page "APSS PO Delay Reasons" = X,
        table "APSS PO Delivery Evaluation" = X,
        tabledata "APSS PO Delivery Evaluation" = RIMD,
        page "APSS PO Delivery Evaluations" = X,
        report "APSS PO Delivery Analysis" = X;
}