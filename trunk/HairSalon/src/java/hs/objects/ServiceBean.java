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

import java.util.Hashtable;

/**
 * This bean holds the information about a service that can be performed by
 * stylists during appointments. Services also consume products when they
 * are pushed through as a sale.
 * 
 * @author Horace Wan
 */
public class ServiceBean extends DataBean implements Comparable
{
	/**
	 * The name of the service.
	 */
	private String name;
	/**
	 * The description of the service.
	 */
	private String description;
	/**
	 * The lenght of time needed for this service in minutes.
	 */
	private Integer duration;
	/**
	 * The hashtable of products consumed by this service, and the quantity of units consued.
	 */
	private Hashtable<ProductBean, Integer> productUse = new Hashtable<ProductBean, Integer> ();
	/**
	 * The price of the service when processed by a sale.
	 */
	private Double price;
	/**
	 * The identification number of the services.
	 */
	private Integer serviceNo;
	/**
	 * The flag used to enable and disable this service in the system.
	 */
	private Boolean enabled = true;

	/**
	 *  Default constructor for the service bean.
	 */
	public ServiceBean ()
	{
	}

	/**
	 * Clones the information of the passed bean into this one.
	 * 
	 * @param bean the bean information to clone.
	 */
	public void clone (ServiceBean bean)
	{
		this.setServiceNo (bean.getServiceNo ());
		this.setName (bean.getName ());
		this.setDescription (bean.getDescription ());
		this.setDuration (bean.getDuration ());
		this.setProductUse (bean.getProductUse ());
		this.setPrice (bean.getPrice());
		this.setEnabled (bean.getEnabled());
	}

	public Double getPrice ()
	{
		return price;
	}

	public void setPrice (Double price)
	{
		this.price = price;
	}

	public void setDescription (String description)
	{
		this.description = description;
	}

	public void setDuration (Integer duration)
	{
		this.duration = duration;
	}

	public void setEnabled (Boolean used)
	{
		this.enabled = used;
	}

	public Boolean getEnabled ()
	{
		return this.enabled;
	}

	public void setName (String name)
	{
		this.name = name;
	}

	public void setProductUse (Hashtable<ProductBean, Integer> productUse)
	{
		this.productUse = productUse;
	}

	public void setServiceNo (Integer serviceNo)
	{
		this.serviceNo = serviceNo;
	}

	public String getDescription ()
	{
		return description;
	}

	public Integer getDuration ()
	{
		return duration;
	}

	public String getName ()
	{
		return name;
	}

	public Hashtable<ProductBean, Integer> getProductUse ()
	{
		return productUse;
	}

	public Integer getServiceNo ()
	{
		return serviceNo;
	}

	public int compareTo (Object o)
	{
		ServiceBean a = (ServiceBean) o;

		return getServiceNo ().compareTo (a.getServiceNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		ServiceBean a = (ServiceBean) o;

		return (a.getServiceNo ().equals (this.getServiceNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 5;
		hash = 71 * hash + (this.serviceNo != null ? this.serviceNo.hashCode () : 0);
		return hash;
	}
}