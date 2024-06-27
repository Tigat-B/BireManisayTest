<%@include file="/senapi/api.jsp"%>

<%
	//impl�mentation d'un client RESTR g�n�rique
	//cr�ation d'un client http
	HttpClient client = new HttpClient();

	// ************** A modifier selon le service voulu ******************//
	//cr�ation d'une m�thode POST avec un URL et des param�tres
	String url="http://localhost/openclinic/senapi/REST_getLastAdmission.jsp";
	PostMethod method = new PostMethod(url);

	//Ici on ajoute l'authentification
	addAuthorizationHeader(request, method);
	
	//Ajouter le param�tre personid 
	addParameter(request, method, "personid", "");
	String format = addParameter(request, method, "format", "");
	// ************** Fin ******************//

	//Ex�cution de la m�thode avec le client http
	client.executeMethod(method);
	
	//R�cup�rer la r�ponse re�ue
	String sResponse = method.getResponseBodyAsString();
	
	// ************** A modifier selon la logique ******************//
	//Affichage de la r�ponse apr�s interpr�tation comme XML
	if(format.equalsIgnoreCase("xmlhtml")){
		out.print(sResponse);
	}
	else{
		Document xmlResponse = DocumentHelper.parseText(sResponse);
		out.println(xmlResponse.getRootElement().attributeValue("code")+": "+
				xmlResponse.getRootElement().getText());
	}
	// ************** Fin ******************//

%>