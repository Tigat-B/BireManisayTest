<%@page import="be.mxs.common.util.tools.sendHtmlMail"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'>
		<td>Maintenance Plan UID</td>
		<td>Email</td>
	</tr>
<%
	//******************************************************************************
	//Recherche de plans de maintenance:
	// - pour lesquels un destinataire e-mail a �t� d�fini
	// - avec dat de d�but dans le pass�
	// - pour lesquels aucune intervention de maintenance n'a encore �t� r�alis�e
	//******************************************************************************
	
	Connection conn = SH.getOpenClinicConnection();
	String sql ="SELECT * FROM oc_maintenanceplans WHERE"+
				" oc_maintenanceplan_startdate<NOW() AND"+
				" length(oc_maintenanceplan_comment9)>0 AND"+
				" (oc_maintenanceplan_enddate IS NULL OR oc_maintenanceplan_enddate>NOW()) and"+
				" NOT EXISTS ("+
				" SELECT * FROM oc_maintenanceoperations WHERE"+
				" oc_maintenanceoperation_maintenanceplanuid="+
				" oc_maintenanceplan_serverid||'.'||oc_maintenanceplan_objectid"+
				" )";
	PreparedStatement ps = conn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String emails = rs.getString("oc_maintenanceplan_comment9");
		String uid=rs.getInt("oc_maintenanceplan_serverid")+"."+rs.getInt("oc_maintenanceplan_objectid");
		//Show maintenanceplan data
		out.println("<tr>"+
						"<td class='admin'>"+uid+"</td>"+
						"<td class='admin2'>"+emails+"</td>"+
					"</tr>");
		//send e-mails
		be.openclinic.assets.Asset asset= 
			be.openclinic.assets.Asset.get(rs.getString("oc_maintenanceplan_assetuid"));
		String mailaddresses[] = emails.split(",");
		for(int n=0;n<mailaddresses.length;n++){
			String smtpServer = "smtp.gmail.com";
			String sFrom = "frank@ict4d.be";
			String sTo = mailaddresses[n];
			String sSubject = "Intervention � faire pour plan de maintenance "+uid;
			String sMessage = "Aucune op�ration r�alis�e � ce jour pour plan "+uid+".<br/>"+  
			  "Equipement ou infrastructure: <b>["+asset.getUid()+"] "+asset.getDescription()+"</b><br/>"+
			  "Service: <b>["+asset.getServiceuid()+"] "+asset.getService().getFullyQualifiedName(sWebLanguage)+"</b><br/>"+
			  "Les interventions auraient d� commencer le <b>"+
							SH.formatDate(rs.getDate("oc_maintenanceplan_startdate"))+"</b>.";
			be.mxs.common.util.tools.sendHtmlMail.sendMail(smtpServer, sFrom, sTo, sSubject, sMessage);
		}
	}
	rs.close();
	ps.close();

	//******************************************************************************
	//Recherche des plans de maintenance:
	// - pour lesquels un destinataire e-mail a �t� d�fini
	// - avec dat de d�but dans le pass�
	// - avec date de fin manquante ou dans l'avenir
	// - pour lesquels la derni�re intervention de maintenance pr�voit une prochaine
	//   intervention avant aujourd'hui + 7 jours
	//******************************************************************************
	sql ="SELECT *,"+
		 " (SELECT oc_maintenanceoperation_nextdate"+
		 " FROM oc_maintenanceoperations"+
		 " WHERE REPLACE(oc_maintenanceoperation_maintenanceplanuid,'1.','')=oc_maintenanceplan_objectid"+
		 " ORDER BY oc_maintenanceoperation_date DESC LIMIT 1) oc_maintenanceoperation_nextdate"+
		 " FROM oc_maintenanceplans"+
		 " WHERE"+
		 " length(oc_maintenanceplan_comment9)>0 and"+
		 " OC_MAINTENANCEPLAN_STARTDATE<NOW() AND"+
		 " (oc_maintenanceplan_enddate>NOW() OR oc_maintenanceplan_enddate is NULL)"+
		 " having"+
		 " oc_maintenanceoperation_nextdate<DATE_ADD(NOW(),INTERVAL 7 DAY)";
	ps = conn.prepareStatement(sql);
	rs = ps.executeQuery();
	while(rs.next()){
		String emails = rs.getString("oc_maintenanceplan_comment9");
		String uid=rs.getInt("oc_maintenanceplan_serverid")+"."+rs.getInt("oc_maintenanceplan_objectid");
		//Show maintenanceplan data
		out.println("<tr>"+
						"<td class='admin'>"+uid+"</td>"+
						"<td class='admin2'>"+emails+"</td>"+
					"</tr>");
		//send e-mails
		be.openclinic.assets.Asset asset= 
			be.openclinic.assets.Asset.get(rs.getString("oc_maintenanceplan_assetuid"));
		String mailaddresses[] = emails.split(",");
		for(int n=0;n<mailaddresses.length;n++){
			String smtpServer = "smtp.gmail.com";
			String sFrom = "frank@ict4d.be";
			String sTo = mailaddresses[n];
			String sSubject = "Intervention � faire pour plan de maintenance "+uid;
			String sMessage = "La prochaine op�ration est pr�vue pour "+
			  SH.formatDate(rs.getDate("oc_maintenanceoperation_nextdate"))+".<br/>"+  
			  "Equipement ou infrastructure: <b>["+asset.getUid()+"] "+asset.getDescription()+"</b><br/>"+
			  "Service: <b>["+asset.getServiceuid()+"] "+asset.getService().getFullyQualifiedName(sWebLanguage)+"</b><br/>";
			be.mxs.common.util.tools.sendHtmlMail.sendMail(smtpServer, sFrom, sTo, sSubject, sMessage);
		}
	}
	rs.close();
	ps.close();
	
	
	conn.close();
%>
</table>