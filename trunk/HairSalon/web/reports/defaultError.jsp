<%-- Declare this page as an error page. --%>
<%@ page isErrorPage="true" %>

<%-- Page Content --%>
<html>
  <head>
      <title>Error!</title>
  </head>
  
  <body>
    <%-- Display the page the error occurred. --%>
    <br/>
    An error occurred on page <b>${param.from}</b>
    <br/><br/>
    
    <%-- Display the exception. --%>
    The exception was:
    <br/>
    <b>${pageContext.exception}</b>
  </body>
</html>