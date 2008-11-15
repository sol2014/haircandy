package hs.app;

/**
 * Used to hold calendar state for one day.
 * 
 * @author Philippe Durand
 */
public class CalendarDayStatus
{
	private int day = 0;
	private boolean hasData = false;
	private boolean hasExceptions = false;
	private String exceptionLabel = "";
	
	public CalendarDayStatus (int day, boolean hasData, boolean hasEx, String label)
	{
		this.day = day;
		this.hasData = hasData;
		this.hasExceptions = hasEx;
		this.exceptionLabel = label;
	}

	public int getDay ()
	{
		return day;
	}

	public void setDay (int day)
	{
		this.day = day;
	}

	public boolean isHasData ()
	{
		return hasData;
	}

	public void setHasData (boolean hasData)
	{
		this.hasData = hasData;
	}

	public boolean isHasExceptions ()
	{
		return hasExceptions;
	}

	public void setHasExceptions (boolean hasExceptions)
	{
		this.hasExceptions = hasExceptions;
	}

	public String getExceptionLabel ()
	{
		return exceptionLabel;
	}

	public void setExceptionLabel (String exceptionLabel)
	{
		this.exceptionLabel = exceptionLabel;
	}
}
