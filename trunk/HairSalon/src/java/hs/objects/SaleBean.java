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

/**
 * This bean holds information about sales that are processed either from
 * walkins or from appointments.
 * 
 * @author Horace Wan
 */
public class SaleBean extends DataBean implements Comparable
{
	/**
	 * A hashtable of the products sold in this sale.
	 */
	private Hashtable<ProductBean, Integer> productSold = new Hashtable<ProductBean, Integer> ();
	/**
	 * A hasthable of the services sold in this sale.
	 */
	private Hashtable<ServiceBean, Integer> serviceSold = new Hashtable<ServiceBean, Integer> ();
	/**
	 * The client bean involved in this sale.
	 */
	private ClientBean client;
	/**
	 * The employee bean this sale is processed by.
	 */
	private EmployeeBean employee;
	/**
	 * The payment method the client used.
	 */
	private String paymentType;
	/**
	 * The total amount client paid for this sale.
	 */
	private Double payment;
	/**
	 * The total tax amount claimed on this sale.
	 */
	private Double totalTax;
	/**
	 * The discount percentage that is applied to this sale.
	 */
	private Integer discount;
	/**
	 * A flag to indicate if this transaction is completed.
	 */
	private Boolean isComplete;
	/**
	 * This is the sale transaction idenification number.
	 */
	private Integer transactionNo;
	/**
	 * The total amount due for this sale.
	 */
	private Double totalDue;

	/**
	 *  Default constructor for the sale bean.
	 */
	public SaleBean ()
	{
	}

	public Integer getDiscount ()
	{
		return discount;
	}

	public void setDiscount (Integer discount)
	{
		this.discount = discount;
	}

	public Double getTotalTax ()
	{
		return totalTax;
	}

	public void setTotalTax (Double totalTax)
	{
		this.totalTax = totalTax;
	}

	public void setClient (ClientBean client)
	{
		this.client = client;
	}

	public void setEmployee (EmployeeBean employee)
	{
		this.employee = employee;
	}

	public void setIsComplete (Boolean isComplete)
	{
		this.isComplete = isComplete;
	}

	public void setPayment (Double payment)
	{
		this.payment = payment;
	}

	public void setPaymentType (String paymentType)
	{
		this.paymentType = paymentType;
	}

	public void setProductSold (Hashtable<ProductBean, Integer> productSold)
	{
		this.productSold = productSold;
	}

	public void setServiceSold (Hashtable<ServiceBean, Integer> serviceSold)
	{
		this.serviceSold = serviceSold;
	}

	public void setTotalDue (Double totalDue)
	{
		this.totalDue = totalDue;
	}

	public void setTransactionNo (Integer transactionNo)
	{
		this.transactionNo = transactionNo;
	}

	public ClientBean getClient ()
	{
		return client;
	}

	public EmployeeBean getEmployee ()
	{
		return employee;
	}

	public Boolean getIsComplete ()
	{
		return isComplete;
	}

	public Double getPayment ()
	{
		return payment;
	}

	public String getPaymentType ()
	{
		return paymentType;
	}

	public Hashtable<ProductBean, Integer> getProductSold ()
	{
		return productSold;
	}

	public Hashtable<ServiceBean, Integer> getServiceSold ()
	{
		return serviceSold;
	}

	public Double getTotalDue ()
	{
		return totalDue;
	}

	public Integer getTransactionNo ()
	{
		return transactionNo;
	}

	public int compareTo (Object o)
	{
		SaleBean a = (SaleBean) o;

		return getTransactionNo ().compareTo (a.getTransactionNo ());
	}

	@Override
	public boolean equals (Object o)
	{
		SaleBean a = (SaleBean) o;

		return (a.getTransactionNo ().equals (this.getTransactionNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 61 * hash + (this.transactionNo != null ? this.transactionNo.hashCode () : 0);
		return hash;
	}
}