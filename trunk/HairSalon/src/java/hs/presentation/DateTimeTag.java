/**
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
        
package hs.presentation;

import java.io.*;
import java.text.*;
import java.util.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

public class DateTimeTag extends TagSupport
{
	public int doStartTag() throws JspException
	{
		DateFormat df = DateFormat.getDateTimeInstance(
				DateFormat.MEDIUM, DateFormat.MEDIUM);
		try{pageContext.getOut().write(df.format(new Date()));}
		catch(IOException ioe)
		{throw new JspTagException(ioe.getMessage());}	
		return SKIP_BODY;
	}
}
