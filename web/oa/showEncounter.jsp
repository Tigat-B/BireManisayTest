<%@page import="be.openclinic.adt.*"%>
<%
	Encounter encounter = Encounter.get("1.1");
%>
Date de d�but: <%= encounter.getBegin() %><br/>
Type de contact: <%= encounter.getType() %><br/>

