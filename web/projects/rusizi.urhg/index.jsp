<%
    response.sendRedirect(request.getRequestURI().replaceAll(request.getServletPath(),"")+"/login.jsp?Title=URHG&Dir=projects/rusizi.urhg/");
%>