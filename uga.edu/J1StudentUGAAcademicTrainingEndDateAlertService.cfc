/**  TITLE:J-1 Student - Academic Training End Date Alerts
IMMI-168 Issue
*/
component extends="AbstractSimpleAlert" {

	public AlertType function getAlertType() {
		var alertType = new AlertType();
		alertType.setServiceID(getImplementedServiceID());
		alertType.setAlertName(getServiceLabelType() & "UGA J-1 Student Academic Training End Date");
		alertType.setAlertDescription("Academic Training end date is within the next 30 days.");
		alertType.setLevelDescription("Low Status Only (UGA)");	
		alertType.setOverride(true);
		return alertType;
	}

	public string function getQueryString() {
		return "
				SELECT
					jbInternational.idnumber
					,jbInternational.campus
					,5 AS threatlevel
					,'This alert shows students who have an Academic Training end date in the next 30 days.' as alertMessage
				FROM 
					sevisDS2019AcademicTraining
					INNER JOIN jbInternational ON jbInternational.idnumber = sevisDS2019AcademicTraining.idnumber
				WHERE
					sevisDS2019AcademicTraining.endDate < GETDATE()+31
					AND
					sevisDS2019AcademicTraining.endDate > GETDATE()
				"
    }

	public boolean function isSEVISAlert() {
		return false;
	}
}
