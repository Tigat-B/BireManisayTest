<%@page import="org.json.JSONObject"%>
<%@page import="org.dom4j.*"%>
<%@page import="org.apache.commons.httpclient.*"%>
<%@page import="org.apache.commons.httpclient.methods.*"%>
<%
	//impl�mentation d'un client RESTR g�n�rique
	//cr�ation d'un client http
	HttpClient client = new HttpClient();

	// ************** A modifier selon le service voulu ******************//
	//cr�ation d'une m�thode POST avec un URL et des param�tres
	String url="http://localhost/openclinic/senapi/serviceREST.jsp";
	PostMethod method = new PostMethod(url);
	//Ajouter le param�tre key avec comme valeur le message fourni
	String msg = request.getParameter("message");
	if(msg==null) msg="Erreur: param�tre message pas fourni";
	method.addParameter("key",msg);
	//Ajouter le param�tre format pour d�finir le format de la r�ponse
	String format = request.getParameter("format");
	if(format==null) format="xml";
	method.addParameter("format",format);
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
	else if(format.equalsIgnoreCase("json")){
		JSONObject json = new JSONObject(sResponse);
		out.println(json.getJSONObject("message").getString("key"));
	}
	else{
		Document xmlResponse = DocumentHelper.parseText(sResponse);
		out.println(xmlResponse.getRootElement().elementText("key"));
	}
	// ************** Fin ******************//
%>