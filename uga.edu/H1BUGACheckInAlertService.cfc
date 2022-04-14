/**  TITLE:UGA H-1B Check-in Required
H-1B/O-1 has a start date within the next 30 days or past 60 days and does not have an approved check-in e-form on file
IMMI-195 Issue
*/
component extends="AbstractSimpleAlert" {

	public AlertType function getAlertType() {
		var alertType = new AlertType();
		alertType.setServiceID(getImplementedServiceID());
		alertType.setAlertName(getServiceLabelType() & "UGA H-1B/O-1 Check-in Required");
		alertType.setAlertDescription("H-1B/O-1 has a start date within the next 30 days or past 60 days and does not have an approved check-in e-form on file.");
		alertType.setLevelDescription("High Status Only (UGA)");	
		alertType.setOverride(true);
		return alertType;
	}

	public string function getQueryString() {
		return "
				SELECT
			
				jbInternational.idnumber
				,jbInternational.campus
				,4 AS threatlevel
				,'H-1B/O-1 has a start date 30 days in the future or 60 days in the past and does not have an approved check-in e-form on file.' as alertMessage
				
			FROM jbEmployeeH1BInfo
			
				INNER JOIN jbInternational ON jbInternational.idnumber = jbEmployeeH1BInfo.idnumber
				
			WHERE 
				jbEmployeeH1BInfo.approvalStartDate <= DATEADD(d,30,GETDATE()) --start date is 30 days or less in the future
				
				AND jbEmployeeH1BInfo.approvalStartDate >= DATEADD(d,-60,GETDATE()) --start date is 60 days or less in the past
				
				AND jbEmployeeH1BInfo.status = 'A' --status on Employment Summary is Approved
				
				AND jbEmployeeH1BInfo.immigrationStatus IN ('H1B','O1')
				--H-1B check-in form 
				AND jbEmployeeH1BInfo.idnumber NOT IN (SELECT idnumber FROM jbEForm WHERE serviceID = 'EFormJ1ScholarImmigrationCheckin0ServiceProvider' AND status = 'Approved')
			
				"
    }

	public boolean function isSEVISAlert() {
		return false;
	}
}
