page 90007 "PO Delivery Evaluation API"
{
    PageType = API;
    SourceTable = "APSS PO Delivery Evaluation";
    Caption = 'APSS PO Delivery Evaluation API';
    APIPublisher = 'apss';
    APIGroup = 'logistics';
    APIVersion = 'v1.0';
    EntityName = 'poDeliveryEvaluation';
    EntitySetName = 'poDeliveryEvaluations';
    ODataKeyFields = SystemId;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'System ID';
                }

                field(purchaseOrderNo; Rec."Purchase Order No.")
                {
                    Caption = 'Purchase Order No.';
                }

                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }

                field(vendorName; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                }

                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }

                field(customerName; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                }

                field(salesOrderNo; Rec."Sales Order No.")
                {
                    Caption = 'Sales Order No.';
                }

                field(buyer; Rec."Purchaser Code")
                {
                    Caption = 'Bill-to Contact';
                }

                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }

                field(expectedReceiptDate; Rec."Expected Receipt Date")
                {
                    Caption = 'Expected Receipt Date';
                }

                field(deliveryTimeliness; Rec."Delivery Timeliness")
                {
                    Caption = 'Delivery Timeliness';
                }

                field(delayReasonCode; Rec."Delay Reason Code")
                {
                    Caption = 'Delay Reason Code';
                }

                field(delayReasonDescription; Rec."Delay Reason Description")
                {
                    Caption = 'Delay Reason Description';
                }

                field(delayExplanation; Rec."Delay Explanation")
                {
                    Caption = 'Delay Explanation';
                }

                field(countsAsDelayed; Rec."Counts as Delayed")
                {
                    Caption = 'Counts as Delayed';
                }

                field(completed; Rec.Completed)
                {
                    Caption = 'Completed';
                }

                field(fullyReceived; Rec."Fully Received")
                {
                    Caption = 'Fully Received';
                }

                field(reminderEnabled; Rec."Reminder Enabled")
                {
                    Caption = 'Reminder Enabled';
                }

                field(reminderFrequency; Rec."Reminder Frequency")
                {
                    Caption = 'Reminder Frequency';
                }

                field(nextFollowUpDate; Rec."Next Follow-up Date")
                {
                    Caption = 'Next Follow-up Date';
                }

                field(manualFollowUpDate; Rec."Manual Follow-up Date")
                {
                    Caption = 'Manual Follow-up Date';
                }

                field(lastReminderSentAt; Rec."Last Reminder Sent At")
                {
                    Caption = 'Last Reminder Sent At';
                }

                field(responsibleUserId; Rec."Responsible User ID")
                {
                    Caption = 'Responsible User ID';
                }

                field(followUpStatus; Rec."Follow-up Status")
                {
                    Caption = 'Follow-up Status';
                }
            }
        }
    }
}
