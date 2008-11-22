<%--
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
 "http://www.w3.org/TR/html4/loose.dtd">
 
<%-- Declare this page as an error page. --%>
<%@ page isErrorPage="true" %>

<%-- Page Content --%>
<html>
  <head>
      <title>Report Error!</title>
  </head>
  
  <body>
    <%-- Display the page the error occurred. --%>
    <br/>
    An error occurred on page <b>${param.from}</b>
    <br/><br/>
    
    <%-- Display the exception. --%>
    The exception was:
    <br/><br/>
    <b>${pageContext.exception}</b><br/>
        
    <a href="report-main-menu.jsp">Return to report main menu</a>
  </body>
</html>