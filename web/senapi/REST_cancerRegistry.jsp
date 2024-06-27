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
	String messageText = "Utilisateur non authentifi&eacute;";
	String format = SH.c(request.getParameter("format"),"xml");

	//Evaluer l'authentification du demandeur du service
	if(isAuthorized(request, "mpi.api.add")){
		//Utilisateur authentifi�, traiter la requ�te
		String patientid = SH.c(request.getParameter("patientid"));
		String ivl = SH.c(request.getParameter("ivl"));
		String iva = SH.c(request.getParameter("iva"));
		String date = SH.c(request.getParameter("date"));
		String age = SH.c(request.getParameter("age"));
		String mat_status = SH.c(request.getParameter("mat_status"));
		String mat_regimen = SH.c(request.getParameter("mat_regimen"));
		String parity = SH.c(request.getParameter("parity"));
		String gestity = SH.c(request.getParameter("gestity"));
		String contraception = SH.c(request.getParameter("contraception"));
		String duration = SH.c(request.getParameter("duration"));
		// V�rifier si certaines donn�es ne sont pas hors limites de l'acceptable
		message="200";
		messageText="OK";
		if(age.length()==0){
			message="501";
			messageText="Age manquant";
		}
		else if(Integer.parseInt(age)<12 || Integer.parseInt(age)>150){
			message="502";
			messageText="Age hors limites";
		}
		else if(ivl.length()==0 && iva.length()==0){
			message="503";
			messageText="Pas de contenu, ivl ou iva obligatoire";
		}
		else if(date.length()==0){
			message="504";
			messageText="Date manquante";
		}
		else if(SH.parseDate(date,"yyyyMMddHHmmss").before(SH.parseDate("20220101","yyyyMMdd"))){
			message="505";
			messageText="Date avant le d&eacute;but du registre";
		}
		else if(SH.parseDate(date,"yyyyMMddHHmmss").after(new java.util.Date())){
			message="506";
			messageText="Date dans le futur";
		}
		else if(patientid.length()==0){
			message="507";
			messageText="Patientid manquant";
		}
		else if(!"vdmc".contains(mat_status.toLowerCase())){
			message="508";
			messageText = "Statut matrimonial non valide";
		}
		else if(!"mp".contains(mat_regimen.toLowerCase())){
			message="509";
			messageText = "R&eacute;gime matrimonial non valide";
		}
		else if(gestity.length()>0 && (Integer.parseInt(gestity)<0 || Integer.parseInt(gestity)>20)){
			message="510";
			messageText = "Valeur de gestit&eacute; erronn&eacute;e";
		}
		else if(parity.length()>0 && (Integer.parseInt(parity)<0 || Integer.parseInt(parity)>20)){
			message="511";
			messageText = "Valeur de parit&eacute; erronn&eacute;e";
		}
		else if(parity.length()>0 && gestity.length()>0 && Integer.parseInt(parity)>0 && Integer.parseInt(gestity)==0){
			message="512";
			messageText = "Accouchment sans grossesse impossible";
		}
		else if(contraception.length()>0 && 
				!"*collar*diu*implant*injection*mama*pill*preservative*".
									contains("*"+contraception.toLowerCase()+"*")){
			message="513";
			messageText = "Contraception inconnue";
		}
		//Si les donn�es sont OK, stocker les donn�es dans une table de registre
		if(message.equalsIgnoreCase("200")){
			//D'abord cr�er la table si elle n'existe pas
			Connection conn = SH.getStatsConnection();
			PreparedStatement ps = conn.prepareStatement("create table if not exists "+
														 " oc_cancerregistry("+
														 " patientid varchar(50),"+
														 " ivl varchar(50),"+
														 " iva varchar(50),"+
														 " date datetime,"+
														 " mat_status varchar(50),"+
														 " mat_regimen varchar(50),"+
														 " parity int,"+
														 " gestity int,"+
														 " contraception varchar(50),"+
														 " duration varchar(50),"+
														 " age int)");
			ps.execute();
			ps.close();
			//Effacer l'ancienne version de cet enregistrement si elle existe
			ps = conn.prepareStatement("delete from oc_cancerregistry where patientid=? "+
									   " and date=?");
			ps.setString(1, patientid);
			ps.setTimestamp(2, new Timestamp(SH.parseDate(date,"yyyyMMddHHmmss").getTime()));
			ps.execute();
			ps.close();
			//Ins�rer l'enregistrement dans la table
			ps=conn.prepareStatement("insert into oc_cancerregistry(patientid,ivl,iva,date,age,"+
									 " mat_status,mat_regimen,gestity,parity,contraception,"+
									 " duration)"+
									 " values(?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, patientid);
			ps.setString(2, ivl);
			ps.setString(3, iva);
			ps.setTimestamp(4, new Timestamp(SH.parseDate(date,"yyyyMMddHHmmss").getTime()));
			ps.setInt(5,Integer.parseInt(age));
			ps.setString(6, mat_status);
			ps.setString(7, mat_regimen);
			ps.setInt(8,gestity.length()==0?-1:Integer.parseInt(gestity));
			ps.setInt(9,parity.length()==0?-1:Integer.parseInt(parity));
			ps.setString(10, contraception);
			ps.setString(11, duration);
			ps.execute();
			ps.close();
			conn.close();
		}
		//Retourner le code d'erreur (200 si OK)
		message="<result code='"+message+"' patientid='"+patientid+"' date='"+date+"'>"+
																	messageText+"</result>";
	}
	else{
		//Retourner le code d'erreur si l'utilisateur n'est pas authoris�
		message="<result code='"+message+"'>"+messageText+"</result>";
	}
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
    
	//Retourner le r�sultat format� dans le body de la r�ponse http
	ServletOutputStream os = response.getOutputStream();
	byte[] b = message.getBytes("utf-8");
	for(int n=0;n<b.length;n++){
		os.write(b[n]);
	}
    os.flush();
	os.close();
%>