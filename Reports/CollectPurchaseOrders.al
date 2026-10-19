codeunit 90010 "APSS Collect Purchase Orders"
{
    procedure RefreshPurchaseOrder(
        PurchaseHeader: Record "Purchase Header")
    var
        InsertedCount: Integer;
        UpdatedCount: Integer;
    begin
        if PurchaseHeader."Document Type" <>
           PurchaseHeader."Document Type"::Order
        then
            exit;

        CreateOrUpdateEvaluation(
            PurchaseHeader,
            InsertedCount,
            UpdatedCount);
    end;

    procedure CollectPurchaseOrders(
        StartDate: Date;
        EndDate: Date;
        var InsertedCount: Integer;
        var UpdatedCount: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        ValidateDateRange(StartDate, EndDate);

        Clear(InsertedCount);
        Clear(UpdatedCount);

        PurchaseHeader.Reset();
        PurchaseHeader.SetRange(
            "Document Type",
            PurchaseHeader."Document Type"::Order);

        PurchaseHeader.SetRange(
            "Order Date",
            StartDate,
            EndDate);

        if PurchaseHeader.FindSet() then
            repeat
                CreateOrUpdateEvaluation(
                    PurchaseHeader,
                    InsertedCount,
                    UpdatedCount);
            until PurchaseHeader.Next() = 0;
    end;

    local procedure CreateOrUpdateEvaluation(
        PurchaseHeader: Record "Purchase Header";
        var InsertedCount: Integer;
        var UpdatedCount: Integer)
    var
        POEvaluation: Record "APSS PO Delivery Evaluation";
        PromisedReceiptDate: Date;
        ExpectedReceiptDate: Date;
        SalesOrderNo: Code[20];
        SalesOrderLineNo: Integer;
        PurchaseLineNo: Integer;
        ItemNo: Code[20];
        ItemDescription: Text[100];
        Quantity: Decimal;
        UnitOfMeasureCode: Code[10];
        CustomerNo: Code[20];
        CustomerName: Text[100];
        CustomerPONo: Code[35];
        BillToContact: Text[100];
        AnalysisNo: Code[20];
        IsNewRecord: Boolean;
    begin
        IsNewRecord :=
            not POEvaluation.Get(PurchaseHeader."No.");

        if IsNewRecord then begin
            POEvaluation.Init();
            POEvaluation."Purchase Order No." :=
                PurchaseHeader."No.";
        end;

        GetOrderReceiptDates(
            PurchaseHeader."No.",
            PromisedReceiptDate,
            ExpectedReceiptDate);

        GetPurchaseLineInformation(
            PurchaseHeader,
            PurchaseLineNo,
            ItemNo,
            ItemDescription,
            Quantity,
            UnitOfMeasureCode,
            SalesOrderNo,
            SalesOrderLineNo);

        AnalysisNo := GetAnalysisNo(PurchaseHeader);

        // If the PO does not carry a direct Sales Order link, use the
        // Opportunity identified by Analysis No. The standard Opportunity
        // field "Sales Document No." contains the created Sales Order No.
        if SalesOrderNo = '' then
            SalesOrderNo :=
                GetSalesOrderNoFromOpportunity(AnalysisNo);

        GetCustomerInformation(
            SalesOrderNo,
            PurchaseHeader,
            CustomerNo,
            CustomerName,
            CustomerPONo,
            BillToContact);

        POEvaluation.Validate(
            "Vendor No.",
            PurchaseHeader."Buy-from Vendor No.");

        POEvaluation."Vendor Name" :=
            PurchaseHeader."Buy-from Vendor Name";

        POEvaluation."Order Date" :=
            PurchaseHeader."Order Date";

        POEvaluation.Validate(
            "Promised Receipt Date",
            PromisedReceiptDate);

        POEvaluation.Validate(
            "Expected Receipt Date",
            ExpectedReceiptDate);

        POEvaluation.Validate(
            "Delivery Timeliness",
            PurchaseHeader."APSS Delivery Timeliness");

        POEvaluation.Validate(
            "Delay Reason Code",
            PurchaseHeader."APSS Delay Reason Code");

        POEvaluation.Validate(
            "Delay Explanation",
            PurchaseHeader."APSS Delay Explanation");

        POEvaluation."Purchaser Code" :=
            BillToContact;

        POEvaluation."Shipment Method Code" :=
            PurchaseHeader."Shipment Method Code";

        POEvaluation."Purchase Line No." :=
            PurchaseLineNo;

        POEvaluation."Item No." :=
            ItemNo;

        POEvaluation."Item Description" :=
            ItemDescription;

        POEvaluation.Quantity :=
            Quantity;

        POEvaluation."Unit of Measure Code" :=
            UnitOfMeasureCode;

        POEvaluation."Sales Order No." :=
            SalesOrderNo;

        POEvaluation."Sales Order Line No." :=
            SalesOrderLineNo;

        POEvaluation."Analysis No." := AnalysisNo;

        POEvaluation."Customer No." :=
            CustomerNo;

        POEvaluation."Customer Name" :=
            CustomerName;

        POEvaluation."Customer PO No." :=
            CustomerPONo;

        POEvaluation.UpdateReceiptStatus();
        POEvaluation.CalculateReminderSchedule();

        if IsNewRecord then begin
            POEvaluation.Insert(true);
            InsertedCount += 1;
        end else begin
            POEvaluation.Modify(true);
            UpdatedCount += 1;
        end;
    end;

    local procedure GetOrderReceiptDates(
        PurchaseOrderNo: Code[20];
        var PromisedReceiptDate: Date;
        var ExpectedReceiptDate: Date)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PromisedReceiptDate);
        Clear(ExpectedReceiptDate);

        PurchaseLine.Reset();

        PurchaseLine.SetRange(
            "Document Type",
            PurchaseLine."Document Type"::Order);

        PurchaseLine.SetRange(
            "Document No.",
            PurchaseOrderNo);

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
    end;

    local procedure GetPurchaseLineInformation(
        PurchaseHeader: Record "Purchase Header";
        var PurchaseLineNo: Integer;
        var ItemNo: Code[20];
        var ItemDescription: Text[100];
        var Quantity: Decimal;
        var UnitOfMeasureCode: Code[10];
        var SalesOrderNo: Code[20];
        var SalesOrderLineNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
        FirstItemCaptured: Boolean;
    begin
        Clear(PurchaseLineNo);
        Clear(ItemNo);
        Clear(ItemDescription);
        Clear(Quantity);
        Clear(UnitOfMeasureCode);
        Clear(SalesOrderNo);
        Clear(SalesOrderLineNo);

        PurchaseLine.Reset();

        PurchaseLine.SetRange(
            "Document Type",
            PurchaseLine."Document Type"::Order);

        PurchaseLine.SetRange(
            "Document No.",
            PurchaseHeader."No.");

        PurchaseLine.SetRange(
            Type,
            PurchaseLine.Type::Item);

        if not PurchaseLine.FindSet() then begin
            SalesOrderNo :=
                GetAPSSSalesOrderNoFromHeader(PurchaseHeader);
            exit;
        end;

        repeat
            if not FirstItemCaptured then begin
                PurchaseLineNo := PurchaseLine."Line No.";
                ItemNo := PurchaseLine."No.";
                ItemDescription := PurchaseLine.Description;
                Quantity := PurchaseLine.Quantity;
                UnitOfMeasureCode := PurchaseLine."Unit of Measure Code";
                FirstItemCaptured := true;
            end;

            // 1. Standard Drop Shipment relationship.
            if PurchaseLine."Sales Order No." <> '' then begin
                SalesOrderNo := PurchaseLine."Sales Order No.";
                SalesOrderLineNo := PurchaseLine."Sales Order Line No.";
                exit;
            end;

            // 2. Standard Special Order relationship.
            if PurchaseLine."Special Order Sales No." <> '' then begin
                SalesOrderNo := PurchaseLine."Special Order Sales No.";
                SalesOrderLineNo := PurchaseLine."Special Order Sales Line No.";
                exit;
            end;
        until PurchaseLine.Next() = 0;

        // 3. APSS custom Purchase Header relationship
        // Field 50002 = APSS SO No. in the external APSS extension.
        SalesOrderNo :=
            GetAPSSSalesOrderNoFromHeader(PurchaseHeader);
    end;

    local procedure GetCustomerInformation(
        SalesOrderNo: Code[20];
        PurchaseHeader: Record "Purchase Header";
        var CustomerNo: Code[20];
        var CustomerName: Text[100];
        var CustomerPONo: Code[35];
        var BillToContact: Text[100])
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
    begin
        Clear(CustomerNo);
        Clear(CustomerName);
        Clear(CustomerPONo);
        Clear(BillToContact);

        // Preferred source: linked Sales Order.
        if SalesOrderNo <> '' then begin
            SalesHeader.Reset();
            SalesHeader.SetRange(
                "Document Type",
                SalesHeader."Document Type"::Order);
            SalesHeader.SetRange(
                "No.",
                SalesOrderNo);

            if SalesHeader.FindFirst() then begin
                CustomerNo :=
                    SalesHeader."Sell-to Customer No.";

                CustomerName :=
                    SalesHeader."Sell-to Customer Name";

                CustomerPONo :=
                    SalesHeader."External Document No.";

                BillToContact :=
                    SalesHeader."Bill-to Contact";

                exit;
            end;
        end;

        // Fallback: standard customer stored on Purchase Header.
        if PurchaseHeader."Sell-to Customer No." <> '' then begin
            CustomerNo :=
                PurchaseHeader."Sell-to Customer No.";

            if Customer.Get(CustomerNo) then
                CustomerName :=
                    Customer.Name;
        end;
    end;

    local procedure GetAnalysisNo(
        PurchaseHeader: Record "Purchase Header"): Code[20]
    var
        PurchaseHeaderRef: RecordRef;
        AnalysisFieldRef: FieldRef;
    begin
        PurchaseHeaderRef.GetTable(PurchaseHeader);

        // External APSS extension:
        // Purchase Header field 50001 = APSS Analysis No.
        if not PurchaseHeaderRef.FieldExist(50001) then
            exit('');

        AnalysisFieldRef :=
            PurchaseHeaderRef.Field(50001);

        exit(
            CopyStr(
                Format(AnalysisFieldRef.Value),
                1,
                20));
    end;

    local procedure GetSalesOrderNoFromOpportunity(
        OpportunityNo: Code[20]): Code[20]
    var
        Opportunity: Record Opportunity;
    begin
        if OpportunityNo = '' then
            exit('');

        if not Opportunity.Get(OpportunityNo) then
            exit('');

        if Opportunity."Sales Document Type" <>
           Opportunity."Sales Document Type"::Order
        then
            exit('');

        exit(Opportunity."Sales Document No.");
    end;

    local procedure GetAPSSSalesOrderNoFromHeader(
        PurchaseHeader: Record "Purchase Header"): Code[20]
    var
        PurchaseHeaderRef: RecordRef;
        SalesOrderFieldRef: FieldRef;
        FieldIndex: Integer;
        FieldName: Text;
        FieldValue: Text;
    begin
        PurchaseHeaderRef.GetTable(PurchaseHeader);

        // External APSS extension:
        // Purchase Header field 50002 = APSS SO No.
        if PurchaseHeaderRef.FieldExist(50002) then begin
            SalesOrderFieldRef := PurchaseHeaderRef.Field(50002);
            FieldName := UpperCase(SalesOrderFieldRef.Name);
            if IsAPSSSalesOrderFieldName(FieldName) then begin
                FieldValue := Format(SalesOrderFieldRef.Value);
                if FieldValue <> '' then
                    exit(CopyStr(FieldValue, 1, 20));
            end;
        end;

        // Fall back to the custom field name in case its field ID differs
        // between versions of the external APSS extension.
        for FieldIndex := 1 to PurchaseHeaderRef.FieldCount do begin
            SalesOrderFieldRef := PurchaseHeaderRef.FieldIndex(FieldIndex);
            FieldName := UpperCase(SalesOrderFieldRef.Name);

            if IsAPSSSalesOrderFieldName(FieldName) then begin
                FieldValue := Format(SalesOrderFieldRef.Value);
                if FieldValue <> '' then
                    exit(CopyStr(FieldValue, 1, 20));
            end;
        end;

        exit('');
    end;

    local procedure IsAPSSSalesOrderFieldName(FieldName: Text): Boolean
    begin
        exit(
            (FieldName = 'APSS SO NO.') or
            (FieldName = 'APSS SO NO') or
            (FieldName = 'APSS SALES ORDER NO.') or
            (FieldName = 'APSS SALES ORDER NO'));
    end;

    local procedure ValidateDateRange(
        StartDate: Date;
        EndDate: Date)
    begin
        if StartDate = 0D then
            Error('You must enter a start date.');

        if EndDate = 0D then
            Error('You must enter an end date.');

        if StartDate > EndDate then
            Error(
                'The start date cannot be later than the end date.');
    end;
}
