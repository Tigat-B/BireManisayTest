<%@page import="net.admin.*"%>
<%
	AdminPerson patient = AdminPerson.get("2");
%>

Nom: <%= patient.lastname %><br/>
Pr�nom: <%= patient.firstname %><br/>
Date de naissance: <%= patient.dateOfBirth %><br/>

