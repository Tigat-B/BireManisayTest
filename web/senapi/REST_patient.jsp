<%@page import="net.admin.AdminPerson"%>
<%@page import="org.json.XML"%>
<%@page import="be.mayele.MayeleAPI"%>
<%@page import="org.dom4j.*"%>
<%
	// ************** A modifier selon le service ******************//
	//R�cup�rer les param�tres utiles
	String personid = request.getParameter("personid");
	String format = request.getParameter("format");
	//Ex�cuter la logique, ex. retourner une repr�sentation XML du patient
	AdminPerson person = AdminPerson.get(personid);
	String message = person.toXml();
	// ************** Fin ******************//

	//Formater le r�sultat de la logique
	if(format!=null && format.equalsIgnoreCase("xmlhtml")){
		message = MayeleAPI.XML2HTML(message);
		//Renvoyer le r�sultat formatt� dans la r�ponse
		response.addHeader("Content-Type", "text/html");
	}
	else if(format!=null && format.equalsIgnoreCase("json")){
		//Renvoyer le r�sultat formatt� dans la r�ponse
		message = XML.toJSONObject(message).toString(4);
		response.addHeader("Content-Type", "application/json");
	}
	else{
		//Renvoyer le r�sultat formatt� dans la r�ponse
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