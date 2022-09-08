/**  TITLE:J1 STUDENT-INTERN endpoint alert
IMMI-159 Issue
*/
component extends="AbstractSimpleAlert" {

	public AlertType function getAlertType() {
		var alertType = new AlertType();
		alertType.setServiceID(getImplementedServiceID());
		alertType.setAlertName(getServiceLabelType() & "UGA Scholar Student-Intern Endpoint Date");
		alertType.setAlertDescription("UGA's Student-Intern endpoint alert. (UGA)");
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
				,'Individual needs an endpoint survey. (UGA)' as alertMessage
			FROM 
				sevisDS2019Program
				INNER JOIN jbInternational on jbInternational.idnumber = sevisDS2019Program.idnumber
			WHERE 
				DATEDIFF(day, prgEndDate, GETDATE()) >= -30 --program ends in the next 30 days
				AND
				jbInternational.idnumber not in (select idnumber from jbEform WHERE serviceid = 'EFormJ1StudentInternEvaluation0ServiceProvider' AND status = 'approved' AND datestamp > DATEADD(day,-30,GETDATE())) --have not submitted evaluation e-form in the past 30 days
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
