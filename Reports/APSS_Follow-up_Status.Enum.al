enum 90013 "APSS Follow-up Status"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }

    value(1; Completed)
    {
        Caption = 'Completed';
    }

    value(2; Escalated)
    {
        Caption = 'Escalated';
    }

    value(3; NotRequired)
    {
        Caption = 'Not Required';
    }
}
