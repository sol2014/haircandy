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

/**
 * This bean holds information about a supplier that brings products to the
 * salon for selling and using during appointments.
 * 
 * @author Horace Wan
 */
public class SupplierBean extends DataBean implements Comparable
{
	/**
	 * The identification number of the supplier.
	 */
	private Integer supplierNo;
	/**
	 * The address bean connected to this supplier.
	 */
	private AddressBean address;
	/**
	 * The list of products that this supplier brings to the salon.
	 */
	private ArrayList<ProductBean> products = new ArrayList<ProductBean> ();
	/**
	 * The name of the supplier.
	 */
	private String name;
	/**
	 * The description of the supplier.
	 */
	private String description;
	/**
	 * The phone number of the supplier.
	 */
	private String phoneNumber;
	/**
	 * A flag used to enable or disable the supplier in the system.
	 */
	private boolean enabled;

	public SupplierBean ()
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

	public int compareTo (Object o)
	{
		SupplierBean a = (SupplierBean) o;

		return getSupplierNo ().compareTo (a.getSupplierNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		SupplierBean a = (SupplierBean) o;

		return (a.getSupplierNo ().equals (this.getSupplierNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 83 * hash + (this.supplierNo != null ? this.supplierNo.hashCode () : 0);
		return hash;
	}
}

