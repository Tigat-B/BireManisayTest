<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@page import="org.json.XML"%>
<%@page import="be.mayele.MayeleAPI"%>
<%@page import="org.dom4j.*"%>
<%@include file="/senapi/api.jsp" %>

<%
	// ************** A modifier selon le service ******************//
	//R�cup�rer les param�tres utiles
	//Ex�cuter la logique, ex. retourner le param�tre key avec
	//un message
	
	String message="401";
	String messageText = "Utilisateur non authentifi�";
	String format = SH.c(request.getParameter("format"),"xml");

	//Evaluer l'authentification du demandeur du service
	if(isAuthorized(request, "mpi.api.select")){
		//Utilisateur authentifi�, traiter la requ�te
		message="200";
		String personid = SH.c(request.getParameter("personid"));
		if(personid.length()>0){
			Connection conn = SH.getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_encounters where "+
														 " oc_encounter_patientuid=? and"+
														 " oc_encounter_type='admission'"+
														 " order by oc_encounter_begindate desc");	
			ps.setString(1,personid);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				messageText=SH.formatDate(rs.getDate("oc_encounter_begindate"));
			}
			else{
				message="201";
				messageText="Aucune hospitalisation pour ce patient";
			}
		}
		else{
			message="501";
			messageText="Personid manquant";
		}
	}
	message="<date code='"+message+"'>"+messageText+"</date>";
	// ************** Fin ******************//

	//Formater le r�sultat de la logique
	if(format!=null && format.equalsIgnoreCase("xmlhtml")){
		message = MayeleAPI.XML2HTML(message);
		//Renvoyer le r�sultat formatt� dans la r�ponse
		response.addHeader("Content-Type", "text/html");
	}
	else{
		//Renvoyer le r�sultat formatt� dans la r�ponse
		response.addHeader("Content-Type", "application/xml");
	}
    
	//Retourner le r�sultat format� dans le body de la r�ponse http
	ServletOutputStream os = response.getOutputStream();
	byte[] b = message.getBytes("utf-8");
	for(int n=0;n<b.length;n++){
		os.write(b[n]);
	}
    os.flush();
	os.close();
%>