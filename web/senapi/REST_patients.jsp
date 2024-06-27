<%@page import="be.mxs.common.util.db.MedwanQuery"%>
<%@page import="java.util.*"%>
<%@page import="net.admin.*"%>
<%@page import="org.json.XML"%>
<%@page import="be.mayele.MayeleAPI"%>
<%@page import="org.dom4j.*"%>
<%@include file="/senapi/api.jsp"%>
<%
	//Authentifier utilisateur
	String message = "<error id='401'>Unauthorized access</error>";
	String format = request.getParameter("format");

	if(isAuthorized(request,"mpi.api.select")){
		// ************** A modifier selon le service ******************//
		//R�cup�rer le body de la requ�te
		String body = getBody(request);
		//R�cup�rer les param�tres utiles
		String personid = request.getParameter("personid");
		String lastname = request.getParameter("lastname");
		String firstname = request.getParameter("firstname");
		String dateofbirth = request.getParameter("dateofbirth");
		message = "<persons>";
		//Ex�cuter la logique, ex. retourner une repr�sentation XML de chaque patient trouv�
		List<AdminPerson> patients = AdminPerson.getAllPatients("", "", "", lastname, firstname, dateofbirth, personid, "");
		Iterator<AdminPerson> ipatients = patients.iterator();
		while(ipatients.hasNext()){
			AdminPerson patient = ipatients.next();
			message += patient.toXml();
		}
		message += "</persons>";
		// ************** Fin ******************//
	}

	//Formater le r�sultat de la logique
	if(format!=null && format.equalsIgnoreCase("xmlhtml")){
		message = MayeleAPI.XML2HTML(message);
		//Renvoyer le r�sultat format� dans la r�ponse
		response.addHeader("Content-Type", "text/html");
	}
	else if(format!=null && format.equalsIgnoreCase("json")){
		//Renvoyer le r�sultat format� dans la r�ponse
		message = XML.toJSONObject(message).toString(4);
		response.addHeader("Content-Type", "application/json");
	}
	else{
		//Renvoyer le r�sultat format� dans la r�ponse
		response.addHeader("Content-Type", "application/xml");
	}
    
	ServletOutputStream os = response.getOutputStream();
	byte[] b = message.getBytes("utf-8");
	for(int n=0;n<b.length;n++){
		os.write(b[n]);
	}
    os.flush();
	os.close();
%>