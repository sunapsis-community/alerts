/**  TITLE:UGA J-1 Student Initial Check-in Required
Student is in Initial SEVIS status and has a start date in the next 30 days
IMMI-190 Issue
*/
component extends="AbstractSimpleAlert" {

	public AlertType function getAlertType() {
		var alertType = new AlertType();
		alertType.setServiceID(getImplementedServiceID());
		alertType.setAlertName(getServiceLabelType() & "UGA J-1 Student Initial Check-in Required");
		alertType.setAlertDescription("Student is in Initial SEVIS status and has a start date in the next 30 days.");
		alertType.setLevelDescription("High Status Only (UGA)");	
		alertType.setOverride(true);
		return alertType;
	}

	public string function getQueryString() {
		return "
			SELECT

				jbInternational.idnumber
				,jbInternational.campus
				,2 AS threatlevel
				,'Student is in Initial/COS/Transfer SEVIS status and has a start date in the next 30 days.' as alertMessage

			FROM sevisDS2019Program,jbInternational

			WHERE 
				sevisDS2019Program.idnumber = jbInternational.idnumber 

				AND status IN ('I','S','T') --I-20 is in Initial, Change of Status, or Transfer status
				
				AND categoryCode IN ('1A','1B','1C','1D','1E','1F') --the J-1 student categories

				AND prgStartDate <= DATEADD(d,30,GETDATE()) --start date is 30 days or less away
				"
    }

	public boolean function isSEVISAlert() {
		return false;
	}
}
