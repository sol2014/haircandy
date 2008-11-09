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
 * This class contains information or attutibe of a sale object.  This class 
 * represents a sale transaction.  Upon creation of an instance of the 
 * following must be provided:
 *  
 * The client and the employee involved in this sale, the product and service 
 * purchased in this transaction, the total of this sale, the amount the 
 * customer paid, the type of payment received, a transaction number and a
 * flag to indicate if the transaction is complete.
 *
 * The above attutibe can be obtain by the getter method.
 * @author Horace Wan
 */
public class SaleBean extends DataBean implements Comparator
{
    /**
     * A key pair for the product(s) sold in this sale.
     */
    private Hashtable<ProductBean, Integer> productSold = new Hashtable<ProductBean, Integer> ();
    /**
     * A key pair for the service(s) performed in this sale.
     */
    private Hashtable<ServiceBean, Integer> serviceSold = new Hashtable<ServiceBean, Integer> ();
    /**
     * The client involved in this sale.
     */
    private ClientBean client;
    /**
     * The employee this sale belong to.
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
	private Double totalTax;
	private Integer discount;
    /**
     * A Boolean flag to indicate if this transaction is finish.
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
     *  Default constructor for person object.
     */
    public SaleBean ()
    {
    }

    /**
     * Sets the client involved in this sale.
     * @param client an object of the client involved in this sale.
     */
    public void setClient (ClientBean client)
    {
        this.client = client;
    }

    /**
     * Sets the employee this sale belong to.
     * @param employee an object of the employee this sale belong to.
     */
    public void setEmployee (EmployeeBean employee)
    {
        this.employee = employee;
    }

    /**
     * Sets the flag to indicate if this transaction is finish.
     * @param isComplete a Boolean flag to indicate if this transaction is 
     *                      finish.
     */
    public void setIsComplete (Boolean isComplete)
    {
        this.isComplete = isComplete;
    }

    /**
     * Sets the total amount client paid for this sale.
     * @param payment a Double of the total amount client paid for this sale.
     */
    public void setPayment (Double payment)
    {
        this.payment = payment;
    }

    /**
     * Sets the payment method the client used.
     * @param paymentType a string for the payment method the client used.
     */
    public void setPaymentType (String paymentType)
    {
        this.paymentType = paymentType;
    }

    /**
     * Sets a key pair for the product(s) sold in this sale.
     * @param productSold a hashing key pair for the product(s) sold in 
     *                      this sale.
     */
    public void setProductSold (Hashtable<ProductBean, Integer> productSold)
    {
        this.productSold = productSold;
    }

    /**
     * Sets a key pair for the service(s) performed in this sale.
     * @param serviceSold a hashing key pair for the service(s) performed 
     *                      in this sale.
     */
    public void setServiceSold (Hashtable<ServiceBean, Integer> serviceSold)
    {
        this.serviceSold = serviceSold;
    }

    /**
     * Sets the total amount due for this sale.
     * @param totalDue a Double of the total amount due for this sale.
     */
    public void setTotalDue (Double totalDue)
    {
        this.totalDue = totalDue;
    }

    /**
     * Sets the sale transaction idenification number.
     * @param transactionNo a string for the sale transaction idenification 
     *                          number.
     */
    public void setTransactionNo (Integer transactionNo)
    {
        this.transactionNo = transactionNo;
    }

    /**
     * Returns the client involved in this sale.
     * @return an object of the client involved in this sale.
     */
    public ClientBean getClient ()
    {
        return client;
    }

    /**
     * Returns the employee this sale belong to.
     * @return an object of the employee this sale belong to.
     */
    public EmployeeBean getEmployee ()
    {
        return employee;
    }

    /**
     * Returns a flag to indicate if this transaction is finish.
     * @return a Boolean flag to indicate if this transaction is finish.
     */
    public Boolean getIsComplete ()
    {
        return isComplete;
    }

    /**
     * Returns the total amount client paid for this sale.
     * @return a Double of the total amount client paid for this sale.
     */
    public Double getPayment ()
    {
        return payment;
    }

    /**
     * Returns the payment method the client used.
     * @return a string for the payment method the client used.
     */
    public String getPaymentType ()
    {
        return paymentType;
    }

    /**
     * Returns a key pair for the product(s) sold in this sale.
     * @return a hashing key pair for the product(s) sold in this sale.
     */
    public Hashtable<ProductBean, Integer> getProductSold ()
    {
        return productSold;
    }

    /**
     * Returns a key pair for the service(s) performed in this sale.
     * @return a hashing key pair for the service(s) performed in this sale.
     */
    public Hashtable<ServiceBean, Integer> getServiceSold ()
    {
        return serviceSold;
    }

    /**
     * Returns the total amount due for this sale.
     * @return a Double of the total amount due for this sale.
     */
    public Double getTotalDue ()
    {
        return totalDue;
    }

    /**
     * Returns the sale transaction idenification number.
     * @return a string for the sale transaction idenification number.
     */
    public Integer getTransactionNo ()
    {
        return transactionNo;
    }
	
	public int compare (Object o1, Object o2)
	{
		SaleBean a1 = (SaleBean)o1;
		SaleBean a2 = (SaleBean)o2;
		
		return a1.getTransactionNo ().compareTo (a2.getTransactionNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		SaleBean a = (SaleBean)o;
		
		return (a.getTransactionNo ().equals (this.getTransactionNo ()));
	}
}