<%@page import="net.admin.*"%>
<%
	User user = User.get(4);
%>
Administrateur syst�me: 
<%=user.getParameter("sa").equalsIgnoreCase("on")?"oui":"non" %>