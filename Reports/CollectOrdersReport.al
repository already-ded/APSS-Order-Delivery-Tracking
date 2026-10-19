report 90010 "APSS Collect Purchase Orders"
{
    Caption = 'Collect Purchase Orders';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ProcessingLoop; Integer)
        {
            DataItemTableView =
                sorting(Number)
                where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                Collector: Codeunit "APSS Collect Purchase Orders";
            begin
                Collector.CollectPurchaseOrders(
                    StartDate,
                    EndDate,
                    InsertedCount,
                    UpdatedCount);
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
                group(Options)
                {
                    Caption = 'Collection Period';

                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip =
                            'Specifies the earliest purchase order date to collect.';
                    }

                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip =
                            'Specifies the latest purchase order date to collect.';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        Message(
            'Purchase order collection completed.\' +
            'New records: %1\' +
            'Updated records: %2',
            InsertedCount,
            UpdatedCount);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        InsertedCount: Integer;
        UpdatedCount: Integer;
}