package hs.app;

/**
 * Used to hold calendar state for one day.
 * 
 * @author pdurand
 */
public class CalendarDayStatus
{
	private int day = 0;
	private boolean hasAppointments = false;
	private boolean hasExceptions = false;
	private String exceptionLabel = "";
	
	public CalendarDayStatus (int day, boolean hasApp, boolean hasEx, String label)
	{
		this.day = day;
		this.hasAppointments = hasApp;
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

	public boolean isHasAppointments ()
	{
		return hasAppointments;
	}

	public void setHasAppointments (boolean hasAppointments)
	{
		this.hasAppointments = hasAppointments;
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
