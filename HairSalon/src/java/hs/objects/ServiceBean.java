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

import java.util.*;

import hs.core.*;

/**
 * This class contains the information or attribute for a service object.
 * This object represents a service an employee can provide for a client.
 * Upon creation of an instance of this object, the following must be 
 * provide:
 *  
 * The name, description, duration, idenification number and the product 
 * consumption of the service.
 *   
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class ServiceBean extends DataBean implements Comparator
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
	 * The lenght of time needed for this service.
	 */
	private Integer duration;
	/**
	 * The amount of product consumed by this service.
	 */
	private Hashtable<ProductBean, Integer> productUse = new Hashtable<ProductBean, Integer> ();
	/**
	 * The service idenification number.
	 */
	private Double price;

	public Double getPrice ()
	{
		return price;
	}

	public void setPrice (Double price)
	{
		this.price = price;
	}
	private Integer serviceNo;
	/**
	 * Whether this service is currently being used.
	 */
	private Boolean enabled = true;
	
	/**
	 *  Default constructor for person object.
	 */
	public ServiceBean ()
	{
	}

	public void clone (ServiceBean bean)
	{
		this.setServiceNo (bean.getServiceNo ());
		this.setName (bean.getName ());
		this.setDescription (bean.getDescription ());
		this.setDuration (bean.getDuration ());
		this.setProductUse (bean.getProductUse ());
	}

	/**
	 * Sets the description of the service.
	 * @param description a string for the description of the service.
	 */
	public void setDescription (String description)
	{
		this.description = description;
	}

	/**
	 * Sets the duration of the service.
	 * @param duration an integer for the duration of the service.
	 */
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
	
	/**
	 * Sets the name of the service.
	 * @param name a string for the name of the service.
	 */
	public void setName (String name)
	{
		this.name = name;
	}

	/**
	 * Sets the amount of product consumed by this service.
	 * @param productUse a hash key pair for the amount of product consumed 
	 *                      by this service.
	 */
	public void setProductUse (Hashtable<ProductBean, Integer> productUse)
	{
		this.productUse = productUse;
	}

	/**
	 * Sets the service idenification number.
	 * @param serviceNo a string for the service idenification number.
	 */
	public void setServiceNo (Integer serviceNo)
	{
		this.serviceNo = serviceNo;
	}

	/**
	 * Returns the description of the service.
	 * @return a string for the description of the service.
	 */
	public String getDescription ()
	{
		return description;
	}

	/**
	 * Returns the duration of the service.
	 * @return an integer for the duration of the service.
	 */
	public Integer getDuration ()
	{
		return duration;
	}

	/**
	 * Returns the name of the service.
	 * @return a string for the name of the service.
	 */
	public String getName ()
	{
		return name;
	}

	/**
	 * Returnsthe amount of product consumed by this service.  
	 * @return a hash key pair for the amount of product consumed by this 
	 *                  service.
	 */
	public Hashtable<ProductBean, Integer> getProductUse ()
	{
		return productUse;
	}

	/**
	 * Returns the service idenification number.
	 * @return a string for the service idenification number.
	 */
	public Integer getServiceNo ()
	{
		return serviceNo;
	}

	public int compare (Object o1, Object o2)
	{
		ServiceBean a1 = (ServiceBean) o1;
		ServiceBean a2 = (ServiceBean) o2;

		return a1.getServiceNo ().compareTo (a2.getServiceNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		ServiceBean a = (ServiceBean) o;

		return (a.getServiceNo ().equals (this.getServiceNo ()));
	}
}