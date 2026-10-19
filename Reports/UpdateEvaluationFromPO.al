codeunit 90011 "APSS PO Evaluation Mgt."
{
    procedure UpdateEvaluationFromPO(
        PurchaseHeader: Record "Purchase Header")
    var
        POEvaluation: Record "APSS PO Delivery Evaluation";
        PurchaseLine: Record "Purchase Line";
        PromisedReceiptDate: Date;
        ExpectedReceiptDate: Date;
        IsNewRecord: Boolean;
    begin
        if PurchaseHeader."Document Type" <>
           PurchaseHeader."Document Type"::Order
        then
            exit;

        IsNewRecord := not POEvaluation.Get(PurchaseHeader."No.");

        if IsNewRecord then begin
            POEvaluation.Init();
            POEvaluation."Purchase Order No." := PurchaseHeader."No.";
        end;

        POEvaluation.Validate(
            "Vendor No.",
            PurchaseHeader."Buy-from Vendor No.");

        POEvaluation."Vendor Name" :=
            PurchaseHeader."Buy-from Vendor Name";

        POEvaluation."Order Date" :=
            PurchaseHeader."Order Date";

        PurchaseLine.SetRange(
            "Document Type",
            PurchaseHeader."Document Type");

        PurchaseLine.SetRange(
            "Document No.",
            PurchaseHeader."No.");

        PurchaseLine.SetFilter(
            Type,
            '<>%1',
            PurchaseLine.Type::" ");

        if PurchaseLine.FindSet() then
            repeat
                if PurchaseLine."Promised Receipt Date" >
                   PromisedReceiptDate
                then
                    PromisedReceiptDate :=
                        PurchaseLine."Promised Receipt Date";

                if PurchaseLine."Expected Receipt Date" >
                   ExpectedReceiptDate
                then
                    ExpectedReceiptDate :=
                        PurchaseLine."Expected Receipt Date";
            until PurchaseLine.Next() = 0;

        POEvaluation.Validate(
            "Promised Receipt Date",
            PromisedReceiptDate);

        POEvaluation.Validate(
            "Expected Receipt Date",
            ExpectedReceiptDate);

        POEvaluation.Validate(
            "Delivery Timeliness",
            PurchaseHeader."APSS Delivery Timeliness");

        POEvaluation."Delay Reason Code" :=
            PurchaseHeader."APSS Delay Reason Code";

        POEvaluation."Delay Explanation" :=
            PurchaseHeader."APSS Delay Explanation";

        if IsNewRecord then
            POEvaluation.Insert(true)
        else
            POEvaluation.Modify(true);
    end;

    procedure UpdatePOFromEvaluation(
        POEvaluation: Record "APSS PO Delivery Evaluation")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if not PurchaseHeader.Get(
            PurchaseHeader."Document Type"::Order,
            POEvaluation."Purchase Order No.")
        then
            Error(
                'Purchase Order %1 is no longer available.',
                POEvaluation."Purchase Order No.");

        PurchaseHeader.Validate(
            "APSS Delivery Timeliness",
            POEvaluation."Delivery Timeliness");

        PurchaseHeader.Validate(
            "APSS Delay Reason Code",
            POEvaluation."Delay Reason Code");

        PurchaseHeader.Validate(
            "APSS Delay Explanation",
            POEvaluation."Delay Explanation");

        PurchaseHeader.Modify(true);
    end;
}