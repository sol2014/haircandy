package hs.presentation;

import java.util.*;
import java.text.*;
import java.io.*;
import javax.servlet.http.HttpServletRequest;

import hs.core.*;

public class ServletHelper
{
	public static String display (Object o)
	{
		if (o == null)
		{
			return "";
		}
		else
		{
			if (o instanceof Date)
			{
				return CoreTools.showDate ((Date) o);
			}
			else
			{
				return o.toString ().trim ();
			}
		}
	}

	public static String displayMax (String str, int max)
	{
		String value = "";

		if (str != null)
		{
			if (str.trim ().length () <= max)
			{
				value = str.trim ();
			}
			else
			{
				value = str.trim ().substring (0, max - 3) + "...";
			}
		}

		return value;
	}
	
	public static String generateHourPicker (String name, Date selected)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (selected);
		int hour = calendar.get (Calendar.HOUR);
		int minutes = calendar.get(Calendar.MINUTE);
		int ampm = calendar.get (Calendar.AM_PM);
		boolean am = false;
		
		if (ampm == Calendar.AM)
			am = true;
		else
		{
			if (hour == 0)
				hour += 12;
			am = false;
		}
		
		String str = "";
		
		// Now do the Hour Selection
		str += "<select name=\""+name+"_hour\" id=\""+name+"_hour\">";
		
		for (int i = 0; i <= 12; i++)
		{
			if (hour == i)
				str += "<option selected=\"selected\" value=\""+i+"\">"+i+"</option>";
			else
				str += "<option value=\""+i+"\">"+i+"</option>";
		}
		
		str += "</select>";
		
		str += ":";
		
		// Now do the Minutes Selection
		str += "<select name=\""+name+"_min\" id=\""+name+"_min\">";
		
		if (minutes == 0)
			str += "<option selected=\"selected\" value=\"00\">00</option>";
		else
			str += "<option value=\"00\">00</option>";
		
		if (minutes == 15)
			str += "<option selected=\"selected\" value=\"15\">15</option>";
		else
			str += "<option value=\"15\">15</option>";
		
		if (minutes == 30)
			str += "<option selected=\"selected\" value=\"30\">30</option>";
		else
			str += "<option value=\"30\">30</option>";
		
		if (minutes == 45)
			str += "<option selected=\"selected\" value=\"45\">45</option>";
		else
			str += "<option value=\"45\">45</option>";
		
		str += "</select>";
		
		str += "&nbsp;";
		
		// Now do AM/PM Selection
		str += "<select name=\""+name+"_ampm\" size=\"1\" id=\""+name+"_ampm\">";
		
		if (ampm == Calendar.AM)
			str += "<option selected=\"selected\" value=\"AM\">AM</option>";
		else
			str += "<option value=\"AM\">AM</option>";
		
		if (ampm == Calendar.PM)
			str += "<option selected=\"selected\" value=\"PM\">PM</option>";
		else
			str += "<option value=\"PM\">PM</option>";
		
		str += "</select>";
		
		return str;
	}
	
	public static String generateTrueFalseOptions (String name, String selected)
	{
		String html = "";

		if (selected == null || selected.length () < 1)
		{
			selected = "True";
		}

		html += "<input type=\"radio\" name=\"" + name + "\" value=\"True\" ";

		if (selected != null && selected.toLowerCase ().equals ("true"))
		{
			html += "checked=\"checked\"";
		}

		html += "/>True";

		html += "<input type=\"radio\" name=\"" + name + "\" value=\"False\" ";

		if (selected != null && selected.toLowerCase ().equals ("false"))
		{
			html += "checked=\"checked\"";
		}

		html += "/>False";

		return html;
	}

	public static String generateOptions (String selected, String[] options)
	{
		String html = "";

		if (options.length < 1)
		{
			return "";
		}
		else
		{
			for (String option : options)
			{
				html += "<option value=\"" + option + "\"";

				if (selected != null && selected.toLowerCase ().equals (option.toLowerCase ()))
				{
					html += "selected=\"selected\"";
				}

				html += ">" + option + "</option>";
			}
		}

		return html;
	}

	public static String generateUserRoleOptions (String selected, boolean withNone)
	{
		String html = "";

		if (withNone)
		{
			html += "<option value=\"None\"";

			if (selected != null && selected.equals ("None"))
			{
				html += "selected=\"selected\"";
			}

			html += ">None</option>";
		}

		for (UserRoles role : UserRoles.values ())
		{
			html += "<option value=\"" + role + "\"";

			if (selected != null && selected.toLowerCase ().equals (role.toString ().toLowerCase ()))
			{
				html += "selected=\"selected\"";
			}

			html += ">" + role + "</option>";
		}
		return html;
	}

	public static String generatePaymentTypeOptions (String selected, boolean withNone)
	{
		String html = "";

		if (withNone)
		{
			html += "<option value=\"None\"";

			if (selected != null && selected.equals ("None"))
			{
				html += "selected=\"selected\"";
			}

			html += ">None</option>";
		}

		for (PaymentTypes type : PaymentTypes.values ())
		{
			html += "<option value=\"" + type + "\"";

			if (selected != null && selected.toLowerCase ().equals (type.toString ().toLowerCase ()))
			{
				html += "selected=\"selected\"";
			}

			html += ">" + type + "</option>";
		}

		return html;
	}

	public static String generateProductTypeOptions (String selected, boolean withNone)
	{
		String html = "";

		if (withNone)
		{
			html += "<option value=\"None\"";

			if (selected != null && selected.equals ("None"))
			{
				html += "selected=\"selected\"";
			}

			html += ">None</option>";
		}

		for (ProductTypes type : ProductTypes.values ())
		{
			html += "<option value=\"" + type + "\"";

			if (selected != null && selected.toLowerCase ().equals (type.toString ().toLowerCase ()))
			{
				html += "selected=\"selected\"";
			}

			html += ">" + type + "</option>";
		}

		return html;
	}
	
	public static String readTimeRequest (HttpServletRequest request, String name)
	{
		String p_hour = name+"_hour";
		String p_minutes = name+"_min";
		String p_ampm = name+"_ampm";
		
		int hour = 0;
		int minutes = 0;
		
		try
		{
			hour = Integer.parseInt (request.getParameter (p_hour));
		}
		catch (Exception e)
		{
		}
		
		try
		{
			minutes = Integer.parseInt (request.getParameter (p_minutes));
		}
		catch (Exception e)
		{
		}
		
		String ampm = request.getParameter (p_ampm);
			
		if (ampm != null && ampm.equals ("PM"))
		{
			if (hour != 12)
				hour += 12;
		}
		else
		{
			if (hour == 12)
				hour = 0;
		}
		
		return (hour+":"+minutes);
	}
	
	public static String generateProductUnitOptions (String selected, boolean withNone)
	{
		String html = "";

		if (withNone)
		{
			html += "<option value=\"None\"";

			if (selected != null && selected.equals ("None"))
			{
				html += "selected=\"selected\"";
			}

			html += ">None</option>";
		}

		for (ProductUnits type : ProductUnits.values ())
		{
			html += "<option value=\"" + type + "\"";

			if (selected != null && selected.toLowerCase ().equals (type.toString ().toLowerCase ()))
			{
				html += "selected=\"selected\"";
			}

			html += ">" + type + "</option>";
		}

		return html;
	}
	
	public static String displayAlertIcon (String levelstr)
	{
		AlertLevels level = AlertLevels.valueOf (levelstr);

		switch (level)
		{
			case Low:
				return "alert-low";
			case Medium:
				return "alert-medium";
			case High:
				return "alert-high";
		}

		return "";
	}
	
	public static String displayPhoneNumber (String rawNumber)
	{
		if (rawNumber == null || rawNumber.equals (""))
		{
			return "No Data";		// First make sure that we have only numbers.

		}
		if (CoreTools.isNumbers (rawNumber))
		{
			if (rawNumber.length () == 10)
			{
				String area = rawNumber.substring (0, 3);
				String first = rawNumber.substring (3, 6);
				String second = rawNumber.substring (6, 10);

				return "(" + area + ") " + first + "-" + second;
			}
			else
			{
				return "Bad Length";
			}
		}
		else
		{
			return "Not Numeric";
		}
	}

	public static String displayPrice (Double price)
	{
		return "$ " + price;
	}
}
