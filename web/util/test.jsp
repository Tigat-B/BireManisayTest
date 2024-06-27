<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="be.bosa.commons.eid.client.*"%>
<%@page import="be.bosa.commons.eid.client.exception.*"%>
<%@page import="be.bosa.commons.eid.consumer.*"%>
<%@page import="be.bosa.commons.eid.consumer.tlv.*"%>

<%
	BeIDCards beIDCardsWithDefaultSettings = new BeIDCards();
	Set<BeIDCard> cards = beIDCardsWithDefaultSettings.getAllBeIDCards();
	out.println(cards.size() + " BeID Cards found<br/>");
	if(cards.size()>0){
		BeIDCard card = beIDCardsWithDefaultSettings.getOneBeIDCard();
		try {
			byte[] idData = card.readFile(FileType.Identity);
			Identity id = TlvParser.parse(idData, Identity.class);
			out.println(id.name + "<br/>");
			idData = card.readFile(FileType.Address);
			Address address = TlvParser.parse(idData, Address.class);
			out.println(address.streetAndNumber + "<br/>");
			idData = card.readFile(FileType.Photo);
			out.println("<img src='data:image/jpg;base64,"+new String(Base64.getEncoder().encode(idData))+"'/>");
		} catch (BeIDException cex) {
			cex.printStackTrace();
		}
	}	
	beIDCardsWithDefaultSettings.close();
%>