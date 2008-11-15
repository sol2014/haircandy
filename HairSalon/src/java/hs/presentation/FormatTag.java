package hs.presentation;

import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import java.io.*;
import java.util.*;
import java.text.*;

public class FormatTag extends BodyTagSupport
{
	//Locale object for internationalization of content.
	private Locale locale;
	
	//Tag Attributes.
	protected String format;
	
	//Static Constants.
	private final static String DATE_LONG = "date";
	private final static String NUMERIC_DECIMAL = "decimal";
	private final static String NUMERIC_ROUNDED = "rounded";
	private final static String NUMERIC_CURRENCY = "currency";
	private final static String PHONE_NUMBER = "phone";
	
	public FormatTag()
	{
		locale = Locale.getDefault();
	}
	
	public void setLocale(Locale locale)
	{
		this.locale = locale;
	}
	
	//Process Tag Body.
	public int doAfterBody() throws JspTagException
	{
		try
		{
			BodyContent body = getBodyContent();
			JspWriter out = body.getEnclosingWriter();
			
			//Get Input Value.
			String textValue = body.getString().trim();
			
			//Output Formatted value.
			out.println(formatValue(textValue));
		}
		catch(IOException e)
		{
			throw new JspTagException(e.toString());
		}
		return SKIP_BODY;
	}
	
	//Process End Tag.
	public int doEndTag() throws JspTagException
	{
		return EVAL_PAGE;
	}
	
	private String formatValue (String _input)
	{
		String formattedValue = "";
		try{
			if(format.equals(DATE_LONG)){
				System.out.println("Old format: " + _input);
				Calendar cal = Calendar.getInstance();
				cal.setTime(DateFormat.getDateInstance(DateFormat.SHORT).parse(_input));
				System.out.println("Old format: " + cal.getTime());
				SimpleDateFormat df = new SimpleDateFormat("EEE, MMM d, yyyy");
				formattedValue = df.format(cal.getTime());
				System.out.println("Old format: " + formattedValue);
			}
			else if(format.equals(NUMERIC_DECIMAL))
			{
				DecimalFormat dcf= (DecimalFormat) NumberFormat.getInstance(locale);
				dcf.setMinimumFractionDigits(2);
				dcf.setMaximumFractionDigits(2);
				formattedValue = dcf.format(dcf.parse(_input));
			}
			else if(format.equals(NUMERIC_ROUNDED))
			{
				DecimalFormat dcf = (DecimalFormat) NumberFormat.getInstance(locale);
				dcf.setMinimumFractionDigits(0);
				dcf.setMaximumFractionDigits(0);
				formattedValue = dcf.format(dcf.parse(_input));
			}
			else if(format.equals(NUMERIC_CURRENCY))
			{
				float num = Float.parseFloat(_input);
				DecimalFormat dcf = (DecimalFormat)
				NumberFormat.getCurrencyInstance();
				formattedValue = dcf.format(num);
			}
			else if(format.equals(PHONE_NUMBER))
			{
				formattedValue = "(" + _input.substring(0, 3) 
					+ ") " +	_input.substring(3, 6) + "-"
					+ _input.substring(6, 10);
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
		return formattedValue;
	}
	
	//Attribute Accessor methdos.
	public String getFormat()
	{
		return this.format;
	}
	
	public void setformat(String _format)
	{
		this.format = _format;
	}
}
