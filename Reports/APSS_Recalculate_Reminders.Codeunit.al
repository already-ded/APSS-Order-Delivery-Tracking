codeunit 90014 "APSS Recalculate Reminders"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        POEvaluation: Record "APSS PO Delivery Evaluation";
    begin
        if POEvaluation.FindSet(true) then
            repeat
                POEvaluation.UpdateReceiptStatus();
                POEvaluation.CalculateReminderSchedule();
                POEvaluation.Modify(true);
            until POEvaluation.Next() = 0;
    end;
}
