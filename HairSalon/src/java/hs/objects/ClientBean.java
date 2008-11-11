/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.objects;

/**
 * This bean holds information about clients who book appointments into the
 * system. These clients are created automatically when appointments are
 * booked for them.
 * 
 * @author Horace Wan
 */
public class ClientBean extends PersonBean implements Comparable
{
	/**
	 * The identification number of the client.
	 */
	private Integer clientNo;
	/**
	 * The address bean attached to this employee.
	 */
	private AddressBean address = null;
	/**
	 * The flag used to enable or disable the record in the system.
	 */
	private boolean enabled = true;

	/**
	 *  Default constructor for the client bean.
	 */
	public ClientBean ()
	{
	}

	public boolean getEnabled ()
	{
		return enabled;
	}

	public void setEnabled (boolean enabled)
	{
		this.enabled = enabled;
	}

	public void setClientNo (Integer clientNo)
	{
		this.clientNo = clientNo;
	}

	public Integer getClientNo ()
	{
		return clientNo;
	}

	public AddressBean getAddress ()
	{
		return address;
	}

	public void setAddress (AddressBean address)
	{
		this.address = address;
	}

	@Override
	public int compareTo (Object o)
	{
		ClientBean a = (ClientBean) o;

		return getClientNo ().compareTo (a.getClientNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		ClientBean a = (ClientBean) o;

		return (a.getClientNo ().equals (this.getClientNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 37 * hash + (this.clientNo != null ? this.clientNo.hashCode () : 0);
		return hash;
	}
}