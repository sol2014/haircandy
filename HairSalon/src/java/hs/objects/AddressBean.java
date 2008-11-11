/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Nuha Bazara
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.objects;

/**
 * This bean contains address information that can be used by
 * any client or employee entity.
 * 
 * @author Nuha Bazara
 */
public class AddressBean extends DataBean implements Comparable
{
	/**
	 * The ioentification number of the address.
	 */
	private Integer addressNo;
	/**
	 * The entity's first address line.
	 */
	private String address1;
	/**
	 * The entity's second address line.
	 */
	private String address2;
	/**
	 * The entity's city.
	 */
	private String city;
	/**
	 * The entity's province.
	 */
	private String province;
	/**
	 * The entity's country.
	 */
	private String country;
	/**
	 * The entity's postal code.
	 */
	private String postalCode;
	/**
	 * The entity's email address.
	 */
	private String email;

	/**
	 *  Default constructor for address bean.
	 */
	public AddressBean ()
	{
	}

	public void setAddressNo (Integer addressNo)
	{
		this.addressNo = addressNo;
	}

	public void setAddress1 (String address1)
	{
		this.address1 = address1;
	}

	public void setAddress2 (String address2)
	{
		this.address2 = address2;
	}

	public void setCity (String city)
	{
		this.city = city;
	}

	public void setProvince (String province)
	{
		this.province = province;
	}

	public void setCountry (String country)
	{
		this.country = country;
	}

	public void setEmail (String email)
	{
		this.email = email;
	}

	public void setPostalCode (String postalCode)
	{
		this.postalCode = postalCode;
	}

	public Integer getAddressNo ()
	{
		return addressNo;
	}

	public String getAddress1 ()
	{
		return address1;
	}

	public String getAddress2 ()
	{
		return address2;
	}

	public String getCity ()
	{
		return city;
	}

	public String getProvince ()
	{
		return province;
	}

	public String getCountry ()
	{
		return country;
	}

	public String getEmail ()
	{
		return email;
	}

	public String getPostalCode ()
	{
		return postalCode;
	}

	public int compareTo (Object o)
	{
		AddressBean a = (AddressBean) o;

		return getAddressNo ().compareTo (a.getAddressNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		AddressBean a = (AddressBean) o;

		return (a.getAddressNo ().equals (this.getAddressNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 3;
		hash = 11 * hash + (this.addressNo != null ? this.addressNo.hashCode () : 0);
		return hash;
	}
}
