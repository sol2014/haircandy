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
 * This class contains information or attutibe of a Address object.
 *
 *  The above attutibe can be obtain by the getter method.
 * 
 * @author Nuha Bazara
 */
public class AddressBean extends DataBean
{
    /**
     *  The preset String length for each variables.
     */
    public static final int ADDRESS_LENGTH = 25;
    public static final int NAME_LENGTH = 15;
    public static final int POSTALCODE_LENGTH = 6;
    public static final int PHONE_NUMBER_LENGTH = 10;
    public static final int EMAIL_LENGTH = 50;
        
    /**
     *  The Address identification number.
     */        
    private Integer addressNo;
    /**
     *  The first line of a Supplier address.
     */
    private String address1;
    /**
     *  The second line of a Supplier address.
     */
    private String address2;
    /**
     *  A Supplier city of residence.
     */
    private String city;
	private String province;
    /**
     *  A Supplier country of residence.
     */
   private String country;
    /**
     *  The postal code of the address.
     */
    private String postalCode;
    /**
     *  The Supplier's e-mail address.
     */
    private String email;

    /**
     *  Default constructor for person object.
     */
    public AddressBean (){}

    /**
     * Sets the Address identification number.
     * @return addressNo a string for the Address identification number.
     */
    public void setAddressNo (Integer addressNo)
    {
        this.addressNo = addressNo;
    }

    /**
     * Sets the first line of a supplier’s address.
     * @param address1 a string for the first line of a supplier’s address.
     */
    public void setAddress1 (String address1)
    {
        this.address1 = address1;
    }

     /**
     * Sets the second line of a supplier’s address.
     * @param address2 a string for the second line of a supplier’s address.
     */
    public void setAddress2 (String address2)
    {
        this.address2 = address2;
    }

    /**
     * Sets the city of the supplier’s location.
     * @param city a string for the city of the supplier’s location.
     */
    public void setCity (String city)
    {
        this.city = city;
    }
	
	public void setProvince (String province)
	{
		this.province = province;
	}
    /**
     * Sets the country of the supplier’s location.
     * @param country a string for the country of the supplier’s location.
     */
    public void setCountry (String country)
    {
        this.country = country;
    }

    /**
     * Sets the email address of the supplier.
     * @param email a string for the email address of the supplier.
     */
    public void setEmail (String email)
    {
        this.email = email;
    }

    /**
     * Sets the postal code of the supplier’s location.
     * @param postalCode a string for the postal code of the supplier’s 
     *                      location.
     */
    public void setPostalCode (String postalCode)
    {
        this.postalCode = postalCode;
    }

    /**
     * Gets the Address identification number.
     * @return a string for the Address identification number.
     */
    public Integer getAddressNo ()
    {
        return addressNo;
    }

    /**
     * Returns the first line of a supplier’s address.
     * @return a string for the first line of a supplier’s address.
     */
    public String getAddress1 ()
    {
        return address1;
    }

    /**
     * Returns the second line of a supplier’s address.
     * @return a string for the second line of a supplier’s address.
     */
    public String getAddress2 ()
    {
        return address2;
    }

    /**
     * Returns the city of the supplier’s location.
     * @return a string for the city of the supplier’s location.
     */
    public String getCity ()
    {
        return city;
    }
	
	public String getProvince ()
	{
		return province;
	}
	
    /**
     * Returns the country of the supplier’s location.
     * @return a string for the country of the supplier’s location.
     */
    public String getCountry ()
    {
        return country;
    }

    /**
     * Returns the email address of the supplier.
     * @return a string for the email address of the supplier.
     */
    public String getEmail ()
    {
        return email;
    }

    /**
     * Returns the postal code of the supplier’s location.
     * @return a string for the postal code of the supplier’s location.
     */
    public String getPostalCode ()
    {
        return postalCode;
    }
	
	public int compare (Object o1, Object o2)
	{
		AddressBean a1 = (AddressBean)o1;
		AddressBean a2 = (AddressBean)o2;
		
		return a1.getAddressNo ().compareTo (a2.getAddressNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		AddressBean a = (AddressBean)o;
		
		return (a.getAddressNo ().equals (this.getAddressNo ()));
	}
}
