/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.presentation.tags;

import hs.core.UserSession;
import hs.objects.EmployeeBean;
import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

/**
 *
 * @author Joey
 */
public class ValidateEmployee implements Tag
{
	private PageContext pageContext;
	private Tag parent;
	private String minimum;

	public void setMinimum (String minimum)
	{
		this.minimum = minimum;
	}

	public String getMinimum ()
	{
		return minimum;
	}

	public int doStartTag () throws JspException
	{
		return SKIP_BODY;
	}

	public int doEndTag () throws JspException
	{
		HttpSession session = pageContext.getSession ();
		UserSession userSession = (UserSession)session.getAttribute ("user_session");
		
		if (userSession.isGuest())
		{
			HttpServletResponse response = (HttpServletResponse) pageContext.getResponse ();
			
			try
			{
				response.sendRedirect (response.encodeRedirectURL ("welcome-guest.jsp"));
			}
			catch (IOException ex)
			{
				Logger.getLogger (ValidateEmployee.class.getName ()).log (Level.SEVERE, null, ex);
			}
			
			return SKIP_PAGE;
		}
		else
		{
			EmployeeBean employee = userSession.getEmployee();
			
			if (minimum.equals ("Manager") && employee.getRole ().equals ("Manager"))
			{
				// Needs a manager, and is a manager.
			}
			else if (minimum.equals ("Receptionist") && (employee.getRole ().equals ("Receptionist") || employee.getRole ().equals ("Manager")))
			{
				// Needs receptionist and has one, or manager.
			}
			else
			{
				HttpServletResponse response = (HttpServletResponse) pageContext.getResponse ();
				
				try
				{
					response.sendRedirect (response.encodeRedirectURL ("welcome-employee.jsp"));
				}
				catch (IOException ex)
				{
					Logger.getLogger (ValidateEmployee.class.getName ()).log (Level.SEVERE, null, ex);
				}

				return SKIP_PAGE;
			}
			
			return EVAL_PAGE;
		}
	}

	public void release ()
	{
	}

	public void setPageContext (PageContext pageContext)
	{
		this.pageContext = pageContext;
	}

	public void setParent (Tag parent)
	{
		this.parent = parent;
	}

	public Tag getParent ()
	{
		return parent;
	}
}
