<%@page import="net.admin.*"%>
<%
	AdminPerson patient = AdminPerson.get("2");
%>

Nom: <%= patient.lastname %><br/>
Prénom: <%= patient.firstname %><br/>
Date de naissance: <%= patient.dateOfBirth %><br/>

