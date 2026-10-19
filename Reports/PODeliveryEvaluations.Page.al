page 90006 "APSS PO Delivery Evaluations"
{
    PageType = List;
    SourceTable = "APSS PO Delivery Evaluation";
    SourceTableView = where(Completed = const(false), "Fully Received" = const(false));
    Caption = 'Purchase Order Delivery Evaluations';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order number.';

                    trigger OnDrillDown()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        if PurchaseHeader.Get(
                            PurchaseHeader."Document Type"::Order,
                            Rec."Purchase Order No.")
                        then
                            Page.Run(Page::"Purchase Order", PurchaseHeader);
                    end;
                }

                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the sales order linked to this purchase order.';

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        if Rec."Sales Order No." = '' then
                            exit;

                        if SalesHeader.Get(
                            SalesHeader."Document Type"::Order,
                            Rec."Sales Order No.")
                        then
                            Page.Run(Page::"Sales Order", SalesHeader);
                    end;
                }

                field("Analysis No."; Rec."Analysis No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the analysis number from the related purchase order.';
                }

                field("Customer PO No."; Rec."Customer PO No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the customer purchase order or external reference.';
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the customer number linked to the sales order.';
                }

                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the customer name.';
                }

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the vendor number.';
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the vendor name.';
                }

                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the purchaser or buyer responsible for the purchase order.';
                }

                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shipment method or Incoterm.';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item or product number.';
                }

                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item description.';
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the ordered quantity.';
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure.';
                }

                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the purchase order date.';
                }

                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the original promised receipt date.';
                }

                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expected Delivery Date';
                    Editable = true;
                    ToolTip = 'Specifies the current expected delivery date. Changes made here are synchronized back to the related purchase order.';

                    trigger OnValidate()
                    var
                        POEvaluationMgt: Codeunit "APSS PO Evaluation Mgt.";
                    begin
                        POEvaluationMgt.UpdatePOFromEvaluation(Rec);
                        CurrPage.Update(false);
                    end;
                }

                field("Days Delay"; Rec."Days Delay")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of days between the promised and expected receipt dates.';
                }

                field("Delivery Timeliness"; Rec."Delivery Timeliness")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the delivery timeliness classification.';

                    trigger OnValidate()
                    var
                        POEvaluationMgt: Codeunit "APSS PO Evaluation Mgt.";
                    begin
                        POEvaluationMgt.UpdatePOFromEvaluation(Rec);
                    end;
                }

                field(IsDelayed; Rec."Counts as Delayed")
                {
                    ApplicationArea = All;
                    Caption = 'Is Delayed';
                    Editable = false;
                    ToolTip = 'Specifies whether the selected delivery classification counts as delayed.';
                }

                field("Delay Reason Code"; Rec."Delay Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the delay reason classification.';

                    trigger OnValidate()
                    var
                        POEvaluationMgt: Codeunit "APSS PO Evaluation Mgt.";
                    begin
                        POEvaluationMgt.UpdatePOFromEvaluation(Rec);
                    end;
                }

                field("Delay Reason Description"; Rec."Delay Reason Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the description of the selected delay reason.';
                }

                field("Delay Explanation"; Rec."Delay Explanation")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies additional details explaining the delivery delay.';

                    trigger OnValidate()
                    var
                        POEvaluationMgt: Codeunit "APSS PO Evaluation Mgt.";
                    begin
                        POEvaluationMgt.UpdatePOFromEvaluation(Rec);
                    end;
                }

                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the delivery evaluation has been completed.';
                }

                field("Fully Received"; Rec."Fully Received")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies that all receivable purchase-order quantities have been posted received. Fully received orders are excluded from active follow-up.';
                }

                field("Reminder Enabled"; Rec."Reminder Enabled")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether Power Automate should send follow-up reminders for this evaluation.';
                }

                field("Reminder Frequency"; Rec."Reminder Frequency")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Calculated automatically from the Expected Receipt Date: current month is weekly, next month is every two weeks, and two or more months ahead is monthly.';
                }

                field("Next Follow-up Date"; Rec."Next Follow-up Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the next follow-up date. Logistics may change this date; a manually selected date is preserved until its reminder is sent.';
                }

                field("Manual Follow-up Date"; Rec."Manual Follow-up Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies that Logistics manually selected the next follow-up date.';
                }

                field("Last Reminder Sent At"; Rec."Last Reminder Sent At")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies when the last follow-up reminder was sent.';
                }

                field("Responsible User ID"; Rec."Responsible User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user responsible for following up with the supplier or logistics team.';
                }

                field("Follow-up Status"; Rec."Follow-up Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the follow-up is pending, completed, escalated, or not required.';
                }

                field("Purchase Line No."; Rec."Purchase Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Last Updated At"; Rec."Last Updated At")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CollectPurchaseOrders)
            {
                ApplicationArea = All;
                Caption = 'Collect Purchase Orders';
                ToolTip = 'Creates or updates evaluation records for purchase orders in a selected date range.';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"APSS Collect Purchase Orders");
                    CurrPage.Update(false);
                end;
            }

            action(PreviewDeliveryReport)
            {
                ApplicationArea = All;
                Caption = 'Preview Report';
                ToolTip = 'Preview the Purchase Order Delivery Analysis report using the current page filters or selected records.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    POEvaluation: Record "APSS PO Delivery Evaluation";
                begin
                    // Pass the filters currently applied to the list page.
                    POEvaluation.CopyFilters(Rec);

                    if POEvaluation.IsEmpty() then
                        Error('There are no evaluation records to preview.');

                    Report.RunModal(
                        Report::"APSS PO Delivery Analysis",
                        true,
                        false,
                        POEvaluation);
                end;
            }
        }
    }
}
