/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.core;

import java.util.*;
import java.io.*;
import java.text.*;

import hs.objects.*;

public class CoreTools
{
	public static final String DateFormat = "dd/MM/yyyy";
	public static final String TimeFormat = "HH:mm";
	public static final String AMPMFormat = "KK:mm a";
	public static final String FullTimeFormat = "KK:mm:ss";
	public static final String MonthYearFormat = "MMMMMMMM, yyyy";
	public static final String DayMonthYearFormat = "EEEEEEEEE, MMMMMMMMM d, yyyy";

	public static boolean containsOnlyNumbers (String str)
	{

		//It can't contain only numbers if it's null or empty...
		if (str == null || str.length () == 0)
		{
			return false;
		}
		for (int i = 0; i < str.length (); i++)
		{

			//If we find a non-digit character we return false.
			if (!Character.isDigit (str.charAt (i)))
			{
				return false;
			}
		}

		return true;
	}

	public static String serializeBase64 (DataBean bean)
	{
		try
		{
			ByteArrayOutputStream os = new ByteArrayOutputStream ();
			ObjectOutputStream out = new ObjectOutputStream (os);

			out.writeObject (bean);
			byte[] output = os.toByteArray ();
			out.close ();

			return Base64.encodeBytes (output);
		}
		catch (IOException ex)
		{
			LogController.write ("Unable to serialize data bean!");
			ex.printStackTrace ();
			return "";
		}
	}

	public static DataBean deserializeBase64 (String data)
	{
		try
		{
			ByteArrayInputStream os = new ByteArrayInputStream (Base64.decode (data));
			ObjectInputStream in = new ObjectInputStream (os);

			Object object = in.readObject ();
			in.close ();

			return (DataBean) object;
		}
		catch (IOException ex)
		{
			LogController.write ("Unable to deserialize data bean! IO Exception!");
			ex.printStackTrace ();
			return null;
		}
		catch (ClassNotFoundException classEx)
		{
			LogController.write ("Unable to deserialize data bean! Class not found!");
			classEx.printStackTrace ();
			return null;
		}
	}

	public static boolean isLettersOrNumbers (String text)
	{
		for (int i = text.length (); i-- > 0;)
		{
			if (Character.isLetterOrDigit (text.charAt (i)))
			{
				return false;
			}
		}

		return true;
	}

	public static boolean isNumbers (String text)
	{
		for (int i = text.length (); i-- > 0;)
		{
			if (!Character.isDigit (text.charAt (i)))
			{
				return false;
			}
		}

		return true;
	}

	public static boolean isLetters (String text)
	{
		for (int i = text.length (); i-- > 0;)
		{
			if (!Character.isLetter (text.charAt (i)))
			{
				return false;
			}
		}

		return true;
	}

	public static int getDaysInMonth (int year, int month)
	{
		int[] daysInMonths = new int[]
		{
			31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
		};
		if (month == 1)
		{
			if ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0)))
			{
				return 28;
			}
			else
			{
				return 29;
			}
		}
		else
		{
			return daysInMonths[month];
		}
	}

	public static int getEndHour (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		if (calendar.get (Calendar.MINUTE) != 0)
		{
			return calendar.get (Calendar.HOUR_OF_DAY) + 1;
		}
		else
		{
			return calendar.get (Calendar.HOUR_OF_DAY);
		}
	}

	public static int getStartHour (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.HOUR_OF_DAY);
	}

	public static int getHour (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.HOUR_OF_DAY);
	}

	public static int getMinutes (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.MINUTE);
	}

	public static int getAMPMHour (int dayHour)
	{
		if (dayHour == 12)
		{
			return 12;
		}
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (new Date ());
		calendar.set (Calendar.HOUR_OF_DAY, dayHour);
		return calendar.get (Calendar.HOUR);
	}

	public static int getWeekDay (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.DAY_OF_WEEK);
	}

	public static String getAMPM (int dayHour)
	{
		if (dayHour == 12)
		{
			return "PM";
		}
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (new Date ());
		calendar.set (Calendar.HOUR_OF_DAY, dayHour);
		if (calendar.get (Calendar.AM_PM) == 1)
		{
			return "PM";
		}
		else
		{
			return "AM";
		}
	}

	public static Date getDate (String datestr)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (DateFormat);
		return sdf.parse (datestr);
	}

	public static Date getTime (String timestr)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (TimeFormat);
		return sdf.parse (timestr);
	}

	public static String showDate (Date date)
	{
		SimpleDateFormat format = new SimpleDateFormat (CoreTools.DateFormat);
		return format.format (date);
	}

	public static String showTime (Date date)
	{
		SimpleDateFormat format = new SimpleDateFormat (CoreTools.TimeFormat);
		return format.format (date);
	}

	public static boolean isDateBefore (Date first, Date second)
	{
		Calendar c = Calendar.getInstance ();
		c.setTime (first);
		int firstDay = c.get (Calendar.DATE);
		int firstMonth = c.get (Calendar.MONTH);
		int firstYear = c.get (Calendar.YEAR);
		c.setTime (second);
		int secondDay = c.get (Calendar.DATE);
		int secondMonth = c.get (Calendar.MONTH);
		int secondYear = c.get (Calendar.YEAR);

		if (firstYear > secondYear)
		{
			return false;
		}
		else if (firstYear == secondYear)
		{
			if (firstMonth > secondMonth)
			{
				return false;
			}
			else if (firstMonth == secondMonth)
			{
				if (firstDay > secondDay)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}

	public static boolean isTimeBefore (Date first, Date second)
	{
		int firstHour = getHour (first);
		int secondHour = getHour (second);
		int firstMinutes = getMinutes (first);
		int secondMinutes = getMinutes (second);

		if (firstHour > secondHour)
		{
			return false;
		}
		else if (firstHour == secondHour)
		{
			// its the same hour, check minutes
			if (firstMinutes > secondMinutes)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}
}
