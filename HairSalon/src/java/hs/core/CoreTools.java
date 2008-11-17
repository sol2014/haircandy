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

/**
 * This class provides miscellaneous tools that are used throughout the 
 * application to perform rendering/serialization/formatting tasks. Also
 * date manipulation and calculations are done here.
 * 
 * @author Philippe Durand
 */
public class CoreTools
{
	public static final String DateFormat = "dd/MM/yyyy";
	public static final String TimeFormat = "HH:mm";
	public static final String TimestampFormat = "yyyy-MM-dd HH:mm";
	public static final String AMPMFormat = "hh:mm a";
	public static final String FullTimeFormat = "HH:mm:ss";
	public static final String MonthYearFormat = "MMMMMMMM, yyyy";
	public static final String DayMonthYearFormat = "EEEEEEEEE, MMMMMMMMM d, yyyy";

	/**
	 * Used to determine if a string contains only numbers.
	 * 
	 * @param str the string to analyze.
	 * @return whether the string contains numbers or not.
	 */
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

	/**
	 * Used to serialize a databean into a base 64 encoded string.
	 * 
	 * @param bean the data bean to serialize and encode.
	 * @return the encoded string containing the object.
	 */
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

	/**
	 * Used to deserialize a database from base 64 encoded string.
	 * 
	 * @param data the data bean string to deserialize and decode.
	 * @return the databean that resulted from the operation.
	 */
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

	/**
	 * Used to determine if the provided string is alphanumeric.
	 * 
	 * @param text the string to analyze.
	 * @return whether the string is alphanumeric or not.
	 */
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

	/**
	 * Used to determine if the provided string is numerical.
	 * 
	 * @param text the string to analyze.
	 * @return whether the string is numerical or not.
	 */
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

	/**
	 * Used to determine if the provided string is alphabetical.
	 * 
	 * @param text the string to analyze.
	 * @return whether the string is alphabetical or not.
	 */
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

	/**
	 * Used to obtain the days that are present in the specified month and year.
	 * 
	 * @param year the year to analyze.
	 * @param month the month to analyze.
	 * @return the number of days found in the month specified.
	 */
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

	/**
	 * Used to obtain the rounded up hour from the date object.
	 * 
	 * @param date the date to analyze.
	 * @return the rounded up hour.
	 */
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

	/**
	 * Used to obtain the hour from the date object.
	 * 
	 * @param date the date to analyze.
	 * @return the hour.
	 */
	public static int getStartHour (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.HOUR_OF_DAY);
	}

	/**
	 * Used to obtain the hour from the date object.
	 * 
	 * @param date the date to analyze.
	 * @return the hour.
	 */
	public static int getHour (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.HOUR_OF_DAY);
	}

	/**
	 * Used to obtain the minutes from the date object.
	 * 
	 * @param date the date to analyze.
	 * @return the minutes.
	 */
	public static int getMinutes (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.MINUTE);
	}

	/**
	 * Used to obtain whether the day hour given lays in the AM or PM.
	 * 
	 * @param dayHour the daytime hour to analyze.
	 * @return a 1 if PM or 0 if AM.
	 */
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
	
	/**
	 * Used to obtain the weekday integer of the date provided.
	 * 
	 * @param date the date to analyze.
	 * @return the weekday integer.
	 */
	public static int getWeekDay (Date date)
	{
		Calendar calendar = Calendar.getInstance ();
		calendar.setTime (date);
		return calendar.get (Calendar.DAY_OF_WEEK);
	}

	/**
	 * Used to obtain the AM/PM string based on the day hour provided.
	 * 
	 * @param dayHour the hour between 1-24.
	 * @return the string "AM" or "PM" based on the hour provided.
	 */
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
	
	/**
	 * Used to obtain the date from a timestamp string using the default format.
	 * 
	 * @param str the timestamp string to analyze.
	 * @return the date object produced.
	 * @throws java.text.ParseException
	 */
	public static Date getTimestamp (String str)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (TimestampFormat);
		return sdf.parse (str);
	}
	
	/**
	 * Used to obtain the date from a timestamp string using the following format.
	 * 
	 * @param str the timestamp string to analyze.
	 * @param format the format to be used.
	 * @return the date object produced.
	 * @throws java.text.ParseException
	 */
	public static Date getTimestamp (String str, String format)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (format);
		return sdf.parse (str);
	}
	
	/**
	 * Used to obtain the date from a date string using the specified format.
	 * 
	 * @param str the date string to analyze.
	 * @param format the format to be used.
	 * @return the date object produced.
	 * @throws java.text.ParseException
	 */
	public static Date getDate (String datestr, String format)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (format);
		return sdf.parse (datestr);
	}
	
	/**
	 * Used to obtain the date from a date string using the default format.
	 * 
	 * @param str the date string to analyze.
	 * @return the date object produced.
	 * @throws java.text.ParseException
	 */
	public static Date getDate (String datestr)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (DateFormat);
		return sdf.parse (datestr);
	}

	/**
	 * Used to obtain the date from a time string using the specified format.
	 * 
	 * @param str the time string to analyze.
	 * @param format the format to be used.
	 * @return the date object produced.
	 * @throws java.text.ParseException
	 */
	public static Date getTime (String timestr, String format)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (format);
		return sdf.parse (timestr);
	}
	
	/**
	 * Used to obtain the date from a time string using the default format.
	 * 
	 * @param str the time string to analyze.
	 * @return the date object produced.
	 * @throws java.text.ParseException
	 */
	public static Date getTime (String timestr)
			throws ParseException
	{
		SimpleDateFormat sdf = new SimpleDateFormat (TimeFormat);
		return sdf.parse (timestr);
	}

	/**
	 * Used to obtain the date string from a date object using the specified format.
	 * 
	 * @param date the date object to convert to string.
	 * @param format the format to be used.
	 * @return the string resulting from the conversion.
	 */
	public static String showDate (Date date, String format)
	{
		SimpleDateFormat sdf = new SimpleDateFormat (format);
		return sdf.format (date);
	}
	
	/**
	 * Used to obtain the date string from a date object using the default format.
	 * 
	 * @param date the date object to convert to string.
	 * @return the string resulting from the conversion.
	 */
	public static String showDate (Date date)
	{
		SimpleDateFormat sdf = new SimpleDateFormat (CoreTools.DateFormat);
		return sdf.format (date);
	}

	/**
	 * Used to obtain the time string from a date object using the specified format.
	 * 
	 * @param date the date object to convert to string.
	 * @param format the format to be used.
	 * @return the resulting string from the conversion.
	 */
	public static String showTime (Date date, String format)
	{
		SimpleDateFormat sdf = new SimpleDateFormat (format);
		return sdf.format (date);
	}
	
	/**
	 * Used to obtain the time string from a date object using the default format.
	 * 
	 * @param date the date object to convert to string.
	 * @return the resulting string from the conversion.
	 */
	public static String showTime (Date date)
	{
		SimpleDateFormat format = new SimpleDateFormat (CoreTools.TimeFormat);
		return format.format (date);
	}

	/**
	 * Used to obtain whether the first date occurs before the second date with
	 * using the date portions of the date object, only time.
	 * 
	 * @param first the first date to compare.
	 * @param second the second date to compare.
	 * @return whether the first date occurs before the second date or not.
	 */
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

	/**
	 * Used to obtain whether the first date occurs after the second date with
	 * using the date portions of the date object, only time.
	 * 
	 * @param first the first date to compare.
	 * @param second the second date to compare.
	 * @return whether the first date occurs after the second date or not.
	 */
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
