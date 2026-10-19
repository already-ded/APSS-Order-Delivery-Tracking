pageextension 90003 "APSS Purchase Order Timing" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("APSS Delivery Timeliness"; Rec."APSS Delivery Timeliness")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    POEvaluationMgt: Codeunit "APSS PO Evaluation Mgt.";
                begin
                    POEvaluationMgt.UpdateEvaluationFromPO(Rec);
                end;
            }

            field("APSS Delay Reason Code";
            Rec."APSS Delay Reason Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    POEvaluationMgt: Codeunit "APSS PO Evaluation Mgt.";
                begin
                    POEvaluationMgt.UpdateEvaluationFromPO(Rec);
                end;
            }

            field("APSS Delay Explanation";
            Rec."APSS Delay Explanation")
            {
                ApplicationArea = All;
                MultiLine = true;
                trigger OnValidate()
                var
                    POEvaluationMgt: Codeunit "APSS PO Evaluation Mgt.";
                begin
                    POEvaluationMgt.UpdateEvaluationFromPO(Rec);
                end;
            }
        }
    }
}
