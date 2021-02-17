import istart.core.StringBuilder;

component extends="SEVISIUInPersonUnderenrollmentAlertService" {
    
    public boolean function isSEVISAlert() {
        return true;
    }

    public string function getQueryString() {
        return new StringBuilder(super.getQueryString()).ln()
            .append(
                "INNER JOIN sevisDS2019Program
                    ON sevisDS2019Program.idnumber = jbInternational.idnumber
                    AND sevisDS2019Program.sevisid = jbInternational.sevisid
                    AND sevisDS2019Program.status IN (
                            SELECT systemValue FROM configFilterSEVISStatusInitial
                            UNION
                            SELECT systemValue FROM configFilterSEVISStatusActive
                        )
                    AND dbo.fnTrunc(CURRENT_TIMESTAMP) 
                    BETWEEN sevisDS2019Program.prgStartDate
                        AND sevisDS2019Program.prgEndDate
                INNER JOIN configFilterJ1StudentCategory
                    ON configFilterJ1StudentCategory.systemValue = sevisDS2019Program.categoryCode"
            ).ln()
            .append(getWhereStatement()).toString();
    }

}