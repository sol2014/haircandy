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

import java.util.ArrayList;
import java.util.Comparator;

/**
 * This class contains information or attutibe of a Supplier object.
 * Upon creation of an instance of the following must be provided:
 * 
 * Customer's first name, last name, address includes city and country, 
 * postal code, phone number and active status.
 *
 *  The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class SupplierBean extends DataBean implements Comparator
{
	/**
	 *  The preset String length for each variables.
	 */
	public static final int ADDRESS_LENGTH = 25;
	public static final int NAME_LENGTH = 50;
	public static final int POSTALCODE_LENGTH = 6;
	public static final int PHONE_NUMBER_LENGTH = 10;
	public static final int EMAIL_LENGTH = 50;
	private Integer supplierNo;
	private AddressBean address;
	private ArrayList<ProductBean> products = new ArrayList<ProductBean> ();
	private String name;
	private String description;
	private String phoneNumber;
	private boolean enabled;

	public boolean getEnabled ()
	{
		return enabled;
	}

	public void setEnabled (boolean enabled)
	{
		this.enabled = enabled;
	}

	public SupplierBean ()
	{
		
	}
	
	public ArrayList<ProductBean> getProducts ()
	{
		return products;
	}

	public void setProducts (ArrayList<ProductBean> products)
	{
		this.products = products;
	}

	public AddressBean getAddress ()
	{
		return address;
	}

	public void setAddress (AddressBean address)
	{
		this.address = address;
	}

	public String getDescription ()
	{
		return description;
	}

	public void setDescription (String description)
	{
		this.description = description;
	}

	public String getPhoneNumber ()
	{
		return phoneNumber;
	}

	public void setPhoneNumber (String phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	public String getName ()
	{
		return name;
	}

	public void setName (String name)
	{
		this.name = name;
	}

	public Integer getSupplierNo ()
	{
		return supplierNo;
	}

	public void setSupplierNo (Integer supplierNo)
	{
		this.supplierNo = supplierNo;
	}
	
	public int compare (Object o1, Object o2)
	{
		SupplierBean a1 = (SupplierBean) o1;
		SupplierBean a2 = (SupplierBean) o2;

		return a1.getSupplierNo ().compareTo (a2.getSupplierNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		SupplierBean a = (SupplierBean) o;

		return (a.getSupplierNo ().equals (this.getSupplierNo ()));
	}
}

