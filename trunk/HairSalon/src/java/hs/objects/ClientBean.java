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
 * This class contains information or attutibe of an Client object.  This 
 * object represents the client who books appointments with the salon.  Upon 
 * creation of an instance of the following must be provided:
 * 
 * The salon(s) this client belongs to. and a client idenification number.
 *
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class ClientBean extends PersonBean
{
	/**
     * The client identification number.
     */
    private Integer clientNo;
    
   
    /**
     * The address record attached to this employee.
     */
    private AddressBean address = null;
	
	private boolean enabled = true;

	public boolean getEnabled ()
	{
		return enabled;
	}

	public void setEnabled (boolean enabled)
	{
		this.enabled = enabled;
	}
	
    /**
     *  Default constructor for person object.
     */
    public ClientBean ()
    {
		
    }
	
    /**
     * Sets the client idenification number.
     * @param clientNo a string for the client idenification number.
     */
    public void setClientNo (Integer clientNo)
    {
        this.clientNo = clientNo;
    }

  
    /**
     * Returns the client idenification number.
     * @return a string for the client idenification number.
     */
    public Integer getClientNo ()
    {
        return clientNo;
    }

   
	
	/**
	 * Returns the address information of this client.
	 * @return the address bean containing the information.
	 */
	public AddressBean getAddress ()
	{
		return address;
	}
	
	/**
	 * Set the address information for this client.
	 * @param address the address bean to set into the client.
	 */
	public void setAddress (AddressBean address)
	{
		this.address = address;
	}
	
	@Override
	public int compare (Object o1, Object o2)
	{
		ClientBean a1 = (ClientBean)o1;
		ClientBean a2 = (ClientBean)o2;
		
		return a1.getClientNo ().compareTo (a2.getClientNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		ClientBean a = (ClientBean)o;
		
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