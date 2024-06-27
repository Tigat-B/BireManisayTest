<%@page import="org.json.XML"%>
<%@page import="be.mayele.MayeleAPI"%>
<%@page import="org.dom4j.*"%>
<%
	// ************** A modifier selon le service ******************//
	//R�cup�rer les param�tres utiles
	String key = request.getParameter("key");
	String format = request.getParameter("format");
	//Ex�cuter la logique, ex. retourner le param�tre key avec
	//un message
	Document document = DocumentHelper.createDocument();
	Element root = document.addElement("message");
	root.addAttribute("text", "Clef fournie par le client");
	Element keyElement = root.addElement("key");
	keyElement.setText(key);
	String message = document.asXML();
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