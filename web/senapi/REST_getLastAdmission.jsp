<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@page import="org.json.XML"%>
<%@page import="be.mayele.MayeleAPI"%>
<%@page import="org.dom4j.*"%>
<%@include file="/senapi/api.jsp" %>

<%
	// ************** A modifier selon le service ******************//
	//Récupérer les paramètres utiles
	//Exécuter la logique, ex. retourner le paramètre key avec
	//un message
	
	String message="401";
	String messageText = "Utilisateur non authentifié";
	String format = SH.c(request.getParameter("format"),"xml");

	//Evaluer l'authentification du demandeur du service
	if(isAuthorized(request, "mpi.api.select")){
		//Utilisateur authentifié, traiter la requête
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

	//Formater le résultat de la logique
	if(format!=null && format.equalsIgnoreCase("xmlhtml")){
		message = MayeleAPI.XML2HTML(message);
		//Renvoyer le résultat formatté dans la réponse
		response.addHeader("Content-Type", "text/html");
	}
	else{
		//Renvoyer le résultat formatté dans la réponse
		response.addHeader("Content-Type", "application/xml");
	}
    
	//Retourner le résultat formaté dans le body de la réponse http
	ServletOutputStream os = response.getOutputStream();
	byte[] b = message.getBytes("utf-8");
	for(int n=0;n<b.length;n++){
		os.write(b[n]);
	}
    os.flush();
	os.close();
%>