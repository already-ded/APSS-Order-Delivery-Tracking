codeunit 90015 "APSS Reset Follow-up Dates"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        POEvaluation: Record "APSS PO Delivery Evaluation";
    begin
        POEvaluation.SetRange(Completed, false);
        POEvaluation.SetRange("Fully Received", false);
        POEvaluation.SetRange("Reminder Enabled", true);

        if POEvaluation.FindSet(true) then
            repeat
                POEvaluation.Validate("Next Follow-up Date", WorkDate());
                POEvaluation.Modify(true);
            until POEvaluation.Next() = 0;
    end;
}
