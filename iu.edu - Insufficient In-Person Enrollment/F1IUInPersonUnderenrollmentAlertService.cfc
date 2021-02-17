import istart.core.StringBuilder;

component extends="SEVISIUInPersonUnderenrollmentAlertService" {
    
    public boolean function isSEVISAlert() {
        return true;
    }

    public string function getQueryString() {
        return new StringBuilder(super.getQueryString()).ln()
            .append(
                "INNER JOIN dbo.sevisI20Program
                    ON sevisI20Program.idnumber = jbInternational.idnumber
                    AND sevisI20Program.sevisid = jbInternational.sevisid
                    AND sevisI20Program.status IN (
                            SELECT systemValue FROM configFilterSEVISStatusInitial
                            UNION
                            SELECT systemValue FROM configFilterSEVISStatusActive
                        )
                    AND dbo.fnTrunc(CURRENT_TIMESTAMP) 
                    BETWEEN sevisI20Program.prgStartDate
                        AND sevisI20Program.prgEndDate"
            ).ln()
            .append(getWhereStatement()).toString();
    }

}