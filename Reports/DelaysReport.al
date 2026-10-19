report 90006 "APSS PO Delivery Analysis"
{
    Caption = 'Purchase Order Delivery Analysis';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ExcelAnalysis;

    dataset
    {
        dataitem(POEvaluation; "APSS PO Delivery Evaluation")
        {
            RequestFilterFields =
                "Purchase Order No.",
                "Sales Order No.",
                "Order Date",
                "Delivery Timeliness",
                "Delay Reason Code";

            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLinkReference = POEvaluation;
                DataItemLink =
                    "Document No." = field("Purchase Order No.");

                DataItemTableView =
                    sorting("Document Type", "Document No.", "Line No.")
                    where(
                        "Document Type" = const(Order),
                        Type = const(Item));

                // -------------------------------------------------
                // ORIGINAL DELIVERY UPDATE REPORT FIELDS
                // -------------------------------------------------

                column(CustomerPO; POEvaluation."Customer PO No.")
                {
                    IncludeCaption = true;
                }

                column(CompanyName; CompanyInformation.Name)
                {
                }

                column(ReportDate; Today)
                {
                }

                column(PreparedBy; PreparedByLbl)
                {
                }

                column(PODate; POEvaluation."Order Date")
                {
                    IncludeCaption = true;
                }

                column(APSSSO; POEvaluation."Sales Order No.")
                {
                    IncludeCaption = true;
                }

                column(Analysis; POEvaluation."Analysis No.")
                {
                    IncludeCaption = true;
                }

                column(Incoterm; POEvaluation."Shipment Method Code")
                {
                    IncludeCaption = true;
                }

                column(Buyer; POEvaluation."Purchaser Code")
                {
                    IncludeCaption = true;
                }

                column(LineNo; DisplayLineNo)
                {
                }

                column(ProductNo; PurchaseLine."No.")
                {
                    IncludeCaption = true;
                }

                column(Qty; PurchaseLine.Quantity)
                {
                    IncludeCaption = true;
                }

                column(UOM; PurchaseLine."Unit of Measure Code")
                {
                    IncludeCaption = true;
                }

                column(CustomerPODeliveryDate; POEvaluation."APSS Initial Prom. Del. Date")
                {
                    IncludeCaption = true;
                }

                column(APSSEstimatedDeliveryDate; POEvaluation."APSS Promised Delivery Date")
                {
                    IncludeCaption = true;
                }

                column(DaysDelayed; POEvaluation."Days Delay")
                {
                }

                column(Remarks; POEvaluation."Delay Explanation")
                {
                    IncludeCaption = true;
                }

                // -------------------------------------------------
                // ADDITIONAL FIELDS
                // -------------------------------------------------

                column(PurchaseOrderNo; POEvaluation."Purchase Order No.")
                {
                    IncludeCaption = true;
                }

                column(CustomerNo; POEvaluation."Customer No.")
                {
                    IncludeCaption = true;
                }

                column(CustomerName; POEvaluation."Customer Name")
                {
                    IncludeCaption = true;
                }

                column(VendorNo; POEvaluation."Vendor No.")
                {
                    IncludeCaption = true;
                }

                column(VendorName; POEvaluation."Vendor Name")
                {
                    IncludeCaption = true;
                }

                column(ItemDescription; PurchaseLine.Description)
                {
                    IncludeCaption = true;
                }

                column(DeliveryTimeliness; POEvaluation."Delivery Timeliness")
                {
                    IncludeCaption = true;
                }

                column(DelayReason; POEvaluation."Delay Reason Description")
                {
                    IncludeCaption = true;
                }

                column(DelayReasonCode; POEvaluation."Delay Reason Code")
                {
                    IncludeCaption = true;
                }

                column(IsDelayed; POEvaluation."Counts as Delayed")
                {
                    IncludeCaption = true;
                }

                column(Completed; POEvaluation.Completed)
                {
                    IncludeCaption = true;
                }

                // Optional / useful technical fields
                column(PurchaseLineNo; PurchaseLine."Line No.")
                {
                    IncludeCaption = true;
                }

                column(SalesOrderLineNo; POEvaluation."Sales Order Line No.")
                {
                    IncludeCaption = true;
                }

                // Keep the existing summary columns on the detail dataitem so
                // the Excel layout does not receive a separate NULL parent row.
                column(OrderCount; OrderCountValue)
                {
                }

                column(DelayedOrderCount; DelayedOrderCountValue)
                {
                }

                trigger OnPreDataItem()
                begin
                    DisplayLineNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    DisplayLineNo += 1;

                    if DisplayLineNo = 1 then begin
                        OrderCountValue := 1;

                        if POEvaluation."Counts as Delayed" then
                            DelayedOrderCountValue := 1
                        else
                            DelayedOrderCountValue := 0;
                    end else begin
                        OrderCountValue := 0;
                        DelayedOrderCountValue := 0;
                    end;

                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange(Completed, false);
                SetRange("Fully Received", false);

                if CustomerNoFilter <> '' then
                    SetRange("Customer No.", CustomerNoFilter);

                if VendorNoFilter <> '' then
                    SetRange("Vendor No.", VendorNoFilter);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Selection)
                {
                    Caption = 'Customer and Vendor Selection';

                    field(CustomerNoSelection; CustomerNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No.';
                        TableRelation = Customer."No.";
                        ToolTip = 'Select the customer to include in the delivery report.';
                    }

                    field(VendorNoSelection; VendorNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.';
                        TableRelation = Vendor."No.";
                        ToolTip = 'Select the vendor to include in the delivery report.';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(ExcelAnalysis)
        {
            Type = Excel;
            Caption = 'Delivery Update Report';
            Summary = 'Customer delivery update report prepared by APSS Logistics.';
            LayoutFile = 'Layouts/PODeliveryAnalysis.xlsx';
        }
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
    end;

    var
        CompanyInformation: Record "Company Information";
        CustomerNoFilter: Code[20];
        VendorNoFilter: Code[20];
        OrderCountValue: Integer;
        DelayedOrderCountValue: Integer;
        DisplayLineNo: Integer;
        PreparedByLbl: Label 'APSS Logistics';
}
