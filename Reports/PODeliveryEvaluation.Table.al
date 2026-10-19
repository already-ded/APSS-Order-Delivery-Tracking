table 90006 "APSS PO Delivery Evaluation"
{
    Caption = 'Purchase Order Delivery Evaluation';
    DataClassification = CustomerContent;
    DataCaptionFields = "Purchase Order No.", "Vendor Name";

    fields
    {
        field(1; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
            NotBlank = true;

            TableRelation = "Purchase Header"."No."
                where("Document Type" = const(Order));

            trigger OnValidate()
            begin
                CopyFromPurchaseOrder();
            end;
        }

        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Vendor No.") then
                    "Vendor Name" := Vendor.Name
                else
                    Clear("Vendor Name");
            end;
        }

        field(3; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }

        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
        }

        field(5; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalculateDaysDelay();
                CalculateReminderSchedule();
            end;
        }

        field(6; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalculateDaysDelay();
            end;
        }

        field(7; "Delivery Timeliness"; Code[20])
        {
            Caption = 'Delivery Timeliness';
            DataClassification = CustomerContent;
            TableRelation = "APSS Delivery Timeliness".Code;

            trigger OnValidate()
            var
                DeliveryTimeliness: Record "APSS Delivery Timeliness";
            begin
                if DeliveryTimeliness.Get("Delivery Timeliness") then
                    "Counts as Delayed" :=
                        DeliveryTimeliness."Counts as Delayed"
                else
                    "Counts as Delayed" := false;
            end;
        }

        field(8; "Counts as Delayed"; Boolean)
        {
            Caption = 'IsDelayed';
            DataClassification = CustomerContent;
        }

        field(9; "Delay Reason Code"; Code[20])
        {
            Caption = 'Delay Reason';
            DataClassification = CustomerContent;
            TableRelation = "APSS PO Delay Reason".Code;

            trigger OnValidate()
            var
                DelayReason: Record "APSS PO Delay Reason";
            begin
                if DelayReason.Get("Delay Reason Code") then
                    "Delay Reason Description" :=
                        DelayReason.Description
                else
                    Clear("Delay Reason Description");
            end;
        }

        field(10; "Delay Reason Description"; Text[100])
        {
            Caption = 'Delay Reason Description';
            DataClassification = CustomerContent;
        }

        field(11; "Delay Explanation"; Text[500])
        {
            Caption = 'Delay Explanation';
            DataClassification = CustomerContent;
        }

        field(12; "Days Delay"; Integer)
        {
            Caption = 'Days Delay from Initial Date';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(13; Completed; Boolean)
        {
            Caption = 'Completed';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalculateReminderSchedule();
            end;
        }

        field(14; "Last Updated At"; DateTime)
        {
            Caption = 'Last Updated At';
            DataClassification = SystemMetadata;
        }

        // -------------------------------------------------
        // SALES ORDER / CUSTOMER INFORMATION
        // -------------------------------------------------

        field(15; "Sales Order No."; Code[20])
        {
            Caption = 'APSS SO';
            DataClassification = CustomerContent;
            Editable = false;

            TableRelation = "Sales Header"."No."
                where("Document Type" = const(Order));
        }

        field(16; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(17; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Customer."No.";
        }

        field(18; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(19; "Customer PO No."; Code[35])
        {
            Caption = 'Customer PO';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // -------------------------------------------------
        // PURCHASE LINE / ITEM INFORMATION
        // -------------------------------------------------

        field(20; "Purchase Line No."; Integer)
        {
            Caption = 'Purchase Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(21; "Item No."; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Item."No.";
        }

        field(22; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(23; Quantity; Decimal)
        {
            Caption = 'Qty.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(24; "Unit of Measure Code"; Code[10])
        {
            Caption = 'UOM';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // -------------------------------------------------
        // OTHER PURCHASE ORDER INFORMATION
        // -------------------------------------------------

        // Legacy field name retained for schema compatibility. Its value is
        // sourced exclusively from Sales Header Bill-to Contact.
        field(25; "Purchaser Code"; Text[100])
        {
            Caption = 'Buyer';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(26; "Shipment Method Code"; Code[10])
        {
            Caption = 'Incoterm';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(27; "Analysis No."; Code[20])
        {
            Caption = 'Analysis No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // -------------------------------------------------
        // FOLLOW-UP REMINDER INFORMATION
        // -------------------------------------------------

        field(28; "Reminder Enabled"; Boolean)
        {
            Caption = 'Reminder Enabled';
            DataClassification = CustomerContent;
        }

        field(29; "Reminder Frequency"; Enum "APSS Reminder Frequency")
        {
            Caption = 'Reminder Frequency';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(30; "Next Follow-up Date"; Date)
        {
            Caption = 'Next Follow-up Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                // Direct assignments made by CalculateReminderSchedule do not
                // invoke this trigger. A user/API validation therefore marks
                // the entered date as a deliberate manual override.
                "Manual Follow-up Date" := "Next Follow-up Date" <> 0D;
            end;
        }

        field(31; "Last Reminder Sent At"; DateTime)
        {
            Caption = 'Last Reminder Sent At';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                // Once the reminder for a manually selected date is sent, the
                // following cycle returns to the automatic frequency schedule.
                "Manual Follow-up Date" := false;
                CalculateReminderSchedule();
            end;
        }

        field(32; "Responsible User ID"; Code[50])
        {
            Caption = 'Responsible User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup"."User ID";
        }

        field(33; "Follow-up Status"; Enum "APSS Follow-up Status")
        {
            Caption = 'Follow-up Status';
            DataClassification = CustomerContent;
        }

        field(34; "Fully Received"; Boolean)
        {
            Caption = 'Fully Received';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(35; "Manual Follow-up Date"; Boolean)
        {
            Caption = 'Manual Follow-up Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Purchase Order No.")
        {
            Clustered = true;
        }

        key(Vendor; "Vendor No.", "Order Date")
        {
        }

        key(DelayReason; "Counts as Delayed", "Delay Reason Code")
        {
        }

        key(Reminder; "Reminder Enabled", "Next Follow-up Date", "Follow-up Status")
        {
        }
    }

    trigger OnInsert()
    begin
        "Last Updated At" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Updated At" := CurrentDateTime;
    end;

    local procedure CopyFromPurchaseOrder()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if "Purchase Order No." = '' then begin
            ClearEvaluationSourceFields();
            exit;
        end;

        PurchaseHeader.Get(
            PurchaseHeader."Document Type"::Order,
            "Purchase Order No.");

        Validate(
            "Vendor No.",
            PurchaseHeader."Buy-from Vendor No.");

        "Vendor Name" :=
            PurchaseHeader."Buy-from Vendor Name";

        "Order Date" :=
            PurchaseHeader."Order Date";

        "Promised Receipt Date" :=
            PurchaseHeader."Promised Receipt Date";

        "Expected Receipt Date" :=
            PurchaseHeader."Expected Receipt Date";

        "Shipment Method Code" :=
            PurchaseHeader."Shipment Method Code";

        CopyFromPurchaseLine();

        CopyFromSalesOrder();

        CalculateDaysDelay();
        UpdateReceiptStatus();
        CalculateReminderSchedule();
    end;

    local procedure CopyFromPurchaseLine()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear("Purchase Line No.");
        Clear("Item No.");
        Clear("Item Description");
        Clear(Quantity);
        Clear("Unit of Measure Code");

        Clear("Sales Order No.");
        Clear("Sales Order Line No.");

        PurchaseLine.Reset();

        PurchaseLine.SetRange(
            "Document Type",
            PurchaseLine."Document Type"::Order);

        PurchaseLine.SetRange(
            "Document No.",
            "Purchase Order No.");

        PurchaseLine.SetRange(
            Type,
            PurchaseLine.Type::Item);

        if not PurchaseLine.FindFirst() then
            exit;

        "Purchase Line No." :=
            PurchaseLine."Line No.";

        "Item No." :=
            PurchaseLine."No.";

        "Item Description" :=
            PurchaseLine.Description;

        Quantity :=
            PurchaseLine.Quantity;

        "Unit of Measure Code" :=
            PurchaseLine."Unit of Measure Code";

        "Sales Order No." :=
            PurchaseLine."Sales Order No.";

        "Sales Order Line No." :=
            PurchaseLine."Sales Order Line No.";
    end;

    local procedure CopyFromSalesOrder()
    var
        SalesHeader: Record "Sales Header";
    begin
        Clear("Customer No.");
        Clear("Customer Name");
        Clear("Customer PO No.");
        Clear("Purchaser Code");

        if "Sales Order No." = '' then
            exit;

        if not SalesHeader.Get(
            SalesHeader."Document Type"::Order,
            "Sales Order No.")
        then
            exit;

        "Customer No." :=
            SalesHeader."Sell-to Customer No.";

        "Customer Name" :=
            SalesHeader."Sell-to Customer Name";

        "Customer PO No." :=
            SalesHeader."External Document No.";

        "Purchaser Code" :=
            SalesHeader."Bill-to Contact";
    end;

    local procedure ClearEvaluationSourceFields()
    begin
        Clear("Vendor No.");
        Clear("Vendor Name");
        Clear("Order Date");
        Clear("Promised Receipt Date");
        Clear("Expected Receipt Date");

        Clear("Sales Order No.");
        Clear("Sales Order Line No.");

        Clear("Customer No.");
        Clear("Customer Name");
        Clear("Customer PO No.");

        Clear("Purchase Line No.");
        Clear("Item No.");
        Clear("Item Description");
        Clear(Quantity);
        Clear("Unit of Measure Code");

        Clear("Purchaser Code");
        Clear("Shipment Method Code");

        Clear("Days Delay");
    end;

    local procedure CalculateDaysDelay()
    var
        CalculatedDays: Integer;
    begin
        if ("Promised Receipt Date" = 0D) or
           ("Expected Receipt Date" = 0D)
        then begin
            "Days Delay" := 0;
            exit;
        end;

        CalculatedDays :=
            "Expected Receipt Date" -
            "Promised Receipt Date";

        if CalculatedDays > 0 then
            "Days Delay" := CalculatedDays
        else
            "Days Delay" := 0;
    end;

    procedure CalculateReminderSchedule()
    var
        CurrentMonthEnd: Date;
        NextMonthEnd: Date;
        LastReminderDate: Date;
    begin
        if Completed or "Fully Received" or ("Expected Receipt Date" = 0D) then begin
            "Reminder Enabled" := false;
            "Next Follow-up Date" := 0D;
            "Manual Follow-up Date" := false;

            if Completed or "Fully Received" then
                "Follow-up Status" := "Follow-up Status"::Completed
            else
                "Follow-up Status" := "Follow-up Status"::NotRequired;

            exit;
        end;

        "Reminder Enabled" := true;
        "Follow-up Status" := "Follow-up Status"::Pending;

        CurrentMonthEnd := CalcDate('<CM>', WorkDate());
        NextMonthEnd := CalcDate('<CM>', CalcDate('<1M>', WorkDate()));

        if "Expected Receipt Date" <= CurrentMonthEnd then
            "Reminder Frequency" := "Reminder Frequency"::Weekly
        else
            if "Expected Receipt Date" <= NextMonthEnd then
                "Reminder Frequency" := "Reminder Frequency"::Biweekly
            else
                "Reminder Frequency" := "Reminder Frequency"::Monthly;

        // Preserve a date deliberately selected by Logistics. The override is
        // cleared when Last Reminder Sent At is validated after the email.
        if "Manual Follow-up Date" and ("Next Follow-up Date" <> 0D) then
            exit;

        if "Last Reminder Sent At" = 0DT then begin
            case "Reminder Frequency" of
                "Reminder Frequency"::Weekly:
                    "Next Follow-up Date" := CalcDate('<7D>', WorkDate());
                "Reminder Frequency"::Biweekly:
                    "Next Follow-up Date" := CalcDate('<14D>', WorkDate());
                "Reminder Frequency"::Monthly:
                    "Next Follow-up Date" := CalcDate('<1M>', WorkDate());
            end;
            exit;
        end;

        LastReminderDate := DT2Date("Last Reminder Sent At");

        case "Reminder Frequency" of
            "Reminder Frequency"::Weekly:
                "Next Follow-up Date" := CalcDate('<7D>', LastReminderDate);
            "Reminder Frequency"::Biweekly:
                "Next Follow-up Date" := CalcDate('<14D>', LastReminderDate);
            "Reminder Frequency"::Monthly:
                "Next Follow-up Date" := CalcDate('<1M>', LastReminderDate);
        end;
    end;

    procedure UpdateReceiptStatus()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        HasReceivableLine: Boolean;
        HasOutstandingQuantity: Boolean;
    begin
        "Fully Received" := false;

        if "Purchase Order No." = '' then
            exit;

        // A PO removed from the open Purchase Header table no longer requires
        // delivery follow-up. This also covers fully posted/closed orders.
        if not PurchaseHeader.Get(
            PurchaseHeader."Document Type"::Order,
            "Purchase Order No.")
        then begin
            "Fully Received" := true;
            exit;
        end;

        PurchaseLine.SetRange(
            "Document Type",
            PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", "Purchase Order No.");
        PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
        PurchaseLine.SetFilter(Quantity, '<>0');

        if PurchaseLine.FindSet() then
            repeat
                HasReceivableLine := true;

                if PurchaseLine."Outstanding Quantity" <> 0 then
                    HasOutstandingQuantity := true;
            until PurchaseLine.Next() = 0;

        "Fully Received" :=
            HasReceivableLine and not HasOutstandingQuantity;
    end;
}
