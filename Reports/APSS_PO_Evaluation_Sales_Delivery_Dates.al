tableextension 90016 "APSS PO Eval Sales Dates" extends "APSS PO Delivery Evaluation"
{
    fields
    {
        field(90016; "Customer Requested Del. Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the delivery date requested by the customer on the linked sales order.';
        }

        field(90017; "APSS Initial Prom. Del. Date"; Date)
        {
            Caption = 'Promised Delivery Date (Initial)';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the original delivery date promised to the customer on the linked sales order.';
        }

        field(90018; "APSS Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the current delivery date promised to the customer on the linked sales order.';
        }
    }
}

pageextension 90017 "APSS PO Eval Sales Dates" extends "APSS PO Delivery Evaluations"
{
    layout
    {
        addafter("Expected Receipt Date")
        {
            field("Customer Requested Del. Date"; Rec."Customer Requested Del. Date")
            {
                ApplicationArea = All;
                Caption = 'Requested Delivery Date';
                Editable = false;
                ToolTip = 'Shows the delivery date requested by the customer on the linked sales order.';
            }

            field("APSS Initial Prom. Del. Date"; Rec."APSS Initial Prom. Del. Date")
            {
                ApplicationArea = All;
                Caption = 'Promised Delivery Date (Initial)';
                Editable = false;
                ToolTip = 'Shows the original delivery date promised to the customer on the linked sales order.';
            }

            field("APSS Promised Delivery Date"; Rec."APSS Promised Delivery Date")
            {
                ApplicationArea = All;
                Caption = 'Promised Delivery Date';
                Editable = false;
                ToolTip = 'Shows the current delivery date promised to the customer on the linked sales order.';
            }
        }
    }
}

codeunit 90018 "APSS PO Eval Sales Dates"
{
    [EventSubscriber(
        ObjectType::Table,
        Database::"APSS PO Delivery Evaluation",
        'OnBeforeInsertEvent',
        '',
        false,
        false)]
    local procedure POEvaluationOnBeforeInsert(
        var Rec: Record "APSS PO Delivery Evaluation";
        RunTrigger: Boolean)
    begin
        CopySalesDeliveryDates(Rec);
    end;

    [EventSubscriber(
        ObjectType::Table,
        Database::"APSS PO Delivery Evaluation",
        'OnBeforeModifyEvent',
        '',
        false,
        false)]
    local procedure POEvaluationOnBeforeModify(
        var Rec: Record "APSS PO Delivery Evaluation";
        var xRec: Record "APSS PO Delivery Evaluation";
        RunTrigger: Boolean)
    begin
        CopySalesDeliveryDates(Rec);
    end;

    [EventSubscriber(
        ObjectType::Table,
        Database::"Sales Header",
        'OnAfterModifyEvent',
        '',
        false,
        false)]
    local procedure SalesHeaderOnAfterModify(
        var Rec: Record "Sales Header";
        var xRec: Record "Sales Header";
        RunTrigger: Boolean)
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if (Rec."Requested Delivery Date" = xRec."Requested Delivery Date") and
           (GetInitialPromisedDeliveryDate(Rec) = GetInitialPromisedDeliveryDate(xRec)) and
           (Rec."Promised Delivery Date" = xRec."Promised Delivery Date")
        then
            exit;

        RefreshEvaluationsForSalesOrder(Rec);
    end;

    local procedure CopySalesDeliveryDates(
        var POEvaluation: Record "APSS PO Delivery Evaluation")
    var
        SalesHeader: Record "Sales Header";
    begin
        Clear(POEvaluation."Customer Requested Del. Date");
        Clear(POEvaluation."APSS Initial Prom. Del. Date");
        Clear(POEvaluation."APSS Promised Delivery Date");

        if POEvaluation."Sales Order No." = '' then
            exit;

        if not SalesHeader.Get(
            SalesHeader."Document Type"::Order,
            POEvaluation."Sales Order No.")
        then
            exit;

        POEvaluation."Customer Requested Del. Date" :=
            SalesHeader."Requested Delivery Date";

        POEvaluation."APSS Initial Prom. Del. Date" :=
            GetInitialPromisedDeliveryDate(SalesHeader);

        POEvaluation."APSS Promised Delivery Date" :=
            SalesHeader."Promised Delivery Date";

        CalculateSalesOrderDaysDelay(POEvaluation);
    end;

    local procedure RefreshEvaluationsForSalesOrder(
        SalesHeader: Record "Sales Header")
    var
        POEvaluation: Record "APSS PO Delivery Evaluation";
    begin
        POEvaluation.SetRange(
            "Sales Order No.",
            SalesHeader."No.");

        if POEvaluation.FindSet(true) then
            repeat
                POEvaluation."Customer Requested Del. Date" :=
                    SalesHeader."Requested Delivery Date";

                POEvaluation."APSS Initial Prom. Del. Date" :=
                    GetInitialPromisedDeliveryDate(SalesHeader);

                POEvaluation."APSS Promised Delivery Date" :=
                    SalesHeader."Promised Delivery Date";

                CalculateSalesOrderDaysDelay(POEvaluation);

                POEvaluation.Modify(false);
            until POEvaluation.Next() = 0;
    end;

    local procedure CalculateSalesOrderDaysDelay(
        var POEvaluation: Record "APSS PO Delivery Evaluation")
    begin
        POEvaluation."Days Delay" := 0;

        if (POEvaluation."APSS Initial Prom. Del. Date" = 0D) or
           (POEvaluation."APSS Promised Delivery Date" = 0D)
        then
            exit;

        if POEvaluation."APSS Promised Delivery Date" >
           POEvaluation."APSS Initial Prom. Del. Date"
        then
            POEvaluation."Days Delay" :=
                POEvaluation."APSS Promised Delivery Date" -
                POEvaluation."APSS Initial Prom. Del. Date";
    end;

    local procedure GetInitialPromisedDeliveryDate(
        SalesHeader: Record "Sales Header"): Date
    var
        SalesHeaderRef: RecordRef;
        InitialDateFieldRef: FieldRef;
        InitialDate: Date;
    begin
        SalesHeaderRef.GetTable(SalesHeader);

        // Existing custom Sales Header field:
        // 50030 = APSS Promised Dev. Date (Init)
        if not SalesHeaderRef.FieldExist(50030) then
            exit(0D);

        InitialDateFieldRef := SalesHeaderRef.Field(50030);

        if Evaluate(InitialDate, Format(InitialDateFieldRef.Value)) then
            exit(InitialDate);

        exit(0D);
    end;
}
