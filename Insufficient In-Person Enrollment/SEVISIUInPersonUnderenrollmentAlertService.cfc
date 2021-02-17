import istart.core.StringBuilder;

component extends="AbstractSimpleAlert" {

    public AlertType function getAlertType() {
        var alertType = new AlertType();
        alertType.setServiceID(getImplementedServiceID());
        alertType.setAlertName(getServiceLabelType() & "Insufficient In-person Enrollment");
        alertType.setAlertDescription("Newly enrolled students are required to be in at least one in-person"
            & " class (P, HY, IS, IN) when they are in the US. Student is not currently enrolled in an in-person"
            & " class and needs to adjust their class schedule.");
        alertType.setLevelDescription("SEVERE Only");
        alertType.setOverride(true);
        return alertType;
    }

    public string function getQueryString() {
        return "SELECT
                jbInternational.idnumber
                , jbInternational.campus
                , jbInternational.sevisid
                , :severe AS threatLevel
                , 'This student is not enrolled in any in-person course credits.' AS alertMessage
            FROM dbo.jbInternational
            INNER JOIN dbo.jbStudentTerm
                ON jbStudentTerm.idnumber = jbInternational.idnumber
                AND jbStudentTerm.newStudentFlag = 1
                AND (
                    jbStudentTerm.credits > 0
                    OR jbStudentTerm.onlineCredits > 0
                )
                AND jbStudentTerm.credits <= jbStudentTerm.onlineCredits
                AND dbo.fnTrunc( CURRENT_TIMESTAMP )
                BETWEEN jbStudentTerm.termStart
                        AND jbStudentTerm.termEnd
            LEFT JOIN dbo.iuieAdmissions
                ON iuieAdmissions.idnumber = jbStudentTerm.idnumber
                AND iuieAdmissions.STU_ADMT_TERM_CD = LEFT(jbStudentTerm.semester, 4)
                AND iuieAdmissions.INST_CD = jbStudentTerm.campus
            LEFT JOIN dbo.iuieAdmissions AS currentAdmission
                ON currentAdmission.idnumber = jbStudentTerm.idnumber
                AND currentAdmission.APPL_PGM_STAT_CD <> 'CN'
                AND currentAdmission.STU_ADMT_TERM_CD = LEFT(jbStudentTerm.semester, 4)
                AND currentAdmission.INST_CD = jbStudentTerm.campus
            LEFT JOIN dbo.jbCustomFields2 AS covid19Data
                ON covid19Data.idnumber = jbInternational.idnumber
                AND covid19Data.customField5 = '1' -- online, out of country";
    }

    private string function getWhereStatement() {
        return "WHERE covid19Data.recnum IS NULL
            AND (
                iuieAdmissions.recnum IS NULL
                OR (
                    iuieAdmissions.recnum IS NOT NULL
                    AND currentAdmission.recnum IS NOT NULL
                )
            )";
    }

}