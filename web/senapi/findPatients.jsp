<%@include file="/senapi/api.jsp"%>

<%
	//impl�mentation d'un client RESTR g�n�rique
	//cr�ation d'un client http
	HttpClient client = new HttpClient();

	// ************** A modifier selon le service voulu ******************//
	//cr�ation d'une m�thode POST avec un URL et des param�tres
	String url="http://localhost/openclinic/senapi/REST_patients.jsp";
	PostMethod method = new PostMethod(url);
	//Ajouter le param�tre key avec comme valeur le message fourni
	addParameter(request, method, "personid", "");
	addParameter(request, method, "lastname", "");
	addParameter(request, method, "firstname", "");
	addParameter(request, method, "dateofbirth", "");
	// ************** Fin ******************//
	
	//Ajouter le param�tre format pour d�finir le format de la r�ponse
	String format=addParameter(request, method, "format", "xml");
	
	//Ex�cution de la m�thode avec le client http
	
	//R�cup�rer la r�ponse re�ue
	String sResponse = method.getResponseBodyAsString();
	
	//Affichage de la r�ponse apr�s interpr�tation comme XML
	if(format.equalsIgnoreCase("xmlhtml")){
		out.print(sResponse);
	}
	// ************** A modifier selon la logique ******************//
	else if(format.equalsIgnoreCase("json")){
		System.out.println(sResponse);
		JSONObject json = new JSONObject(sResponse);
		if(json.has("error") && json.get("error") instanceof JSONObject){
			out.println(sResponse);
		}
		else if(json.get("persons") instanceof JSONObject){
			if(json.getJSONObject("persons").get("person") instanceof JSONArray){
				JSONArray array = json.getJSONObject("persons").getJSONArray("person");
				for(int n=0;n<array.length();n++){
					JSONObject person = array.getJSONObject(n);
					String lastname = person.getString("lastname");
					String firstname = person.getString("firstname");
					String dob = person.getString("dateofbirth");
					out.println("<b>"+lastname+", "+firstname+"</b> �"+dob+"<br/>");
				}
			}
			else if(json.getJSONObject("persons").get("person") instanceof JSONObject){
				JSONObject person = json.getJSONObject("persons").getJSONObject("person");
				String lastname = person.getString("lastname");
				String firstname = person.getString("firstname");
				String dob = person.getString("dateofbirth");
				out.println("<b>"+lastname+", "+firstname+"</b> �"+dob+"<br/>");
			}
		}
		else{
			out.println("Aucun patient trouv�");
		}
	}
	else{
		Document xmlResponse = DocumentHelper.parseText(sResponse);
		Element persons = xmlResponse.getRootElement();
		if(persons.getName().equalsIgnoreCase("error")){
			out.println(persons.attributeValue("id")+": "+persons.getText());
		}
		else{
			Iterator<Element> ipersons = persons.elementIterator("person");
			while(ipersons.hasNext()){
				Element person = ipersons.next();
				String lastname = person.elementText("lastname");
				String firstname = person.elementText("firstname");
				String dob = person.elementText("dateofbirth");
				out.println("<b>"+lastname+", "+firstname+"</b> �"+dob+"<br/>");
			}
		}		
	}
	// ************** Fin ******************//
%>