/**  TITLE:J1 STUDENT-INTERN midpoint alert
IMMI-116 Issue
*/
component extends="AbstractSimpleAlert" {

	public AlertType function getAlertType() {
		var alertType = new AlertType();
		alertType.setServiceID(getImplementedServiceID());
		alertType.setAlertName(getServiceLabelType() & "UGA Scholar Student-Intern Midpoint Date");
		alertType.setAlertDescription("UGA's Student-Intern midpoint alert. (UGA)");
		alertType.setLevelDescription("Severe level only");	
		alertType.setOverride(true);
		return alertType;
	}

	public string function getQueryString() {
		return "
			SELECT
				jbInternational.idnumber
				,jbInternational.campus
				,1 AS threatlevel
				,'Individual needs a midpoint survey. (UGA)' as alertMessage
			FROM 
				sevisDS2019Program
				INNER JOIN jbInternational on jbInternational.idnumber = sevisDS2019Program.idnumber
			WHERE 
				DATEDIFF(day, prgStartDate, prgEndDate) >= 180
				AND
				DATEADD(day, DATEDIFF(day, prgStartDate, prgEndDate) / 2, prgStartDate) < GETDATE()
				AND
				jbInternational.idnumber not in (select idnumber from jbEform WHERE serviceid = 'EFormJ1StudentInternEvaluation0ServiceProvider' AND status = 'approved' AND datestamp > prgStartDate)
				AND
				status in ('A')
				AND
				categoryCode in ('1G')
		"
    }

	public boolean function isSEVISAlert() {
		return false;
	}
}
