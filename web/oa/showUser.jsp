Solution exercice 1:
================================
<%@page import="net.admin.*"%>
<%
	User user = User.get(4);
%>

Nom: <%= user.person.lastname %><br/>
Pr�nom: <%= user.person.firstname %><br/>

================================

Exercice 2: v�rifiez si le mot de passe de l'utilisateur avec 
ID 4 est "openclinic" dans oa/validateUser.jsp
	
Exercice 3: v�rifiez si l'utilisateur avec ID 4 est un 
administrateur syst�me	 (valeur du param�tre "sa") dans 
oa/checkSA.jsp
