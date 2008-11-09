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

import java.util.Comparator;

/**
 * This class contains information or attutibe of a product object.  This 
 * class represents a product consume or sold in the inventory.  Upon 
 * creation of an instance of the following must be provided:
 *  
 * The product's name, brand, id number, type, current stock quantity, the 
 * minimum required quantity in stock, price, unit measurment, a tag of the 
 * current status and unit amount.
 *
 * The above attutibe can be obtain by the getter method.  There are two 
 * methods to add and substract the stock quantity.
 * @author Horace Wan
 */
public class ProductBean extends DataBean implements Comparator
{
    /**
     * The name of the product.
     */
    private String name;
    /**
     * The brand of the product.
     */
    private String brand;
    /**
     * The product identification number.
     */
    private Integer productNo;
    /**
     * The product type.
     */
    private String type;
    /**
     * The quantity of the product currently available in inventory.
     */
    private Integer stockQty;
    /**
     * This is the minimum quantity of the product requires having before an 
     * order has to be place.
     */
    private Integer minLevel;
    /**
     * The price of ONE product.
     */
    private Double price;
    /**
     * The measurement in ONE product.
     */
    private String unit;
    /**
     * The tag to indicate if the product needs to be reported.
     */
    private boolean enabled = true;
    /**
     * The unit amount in ONE product.
     */
    private Integer qtyPer;

    /**
     *  Default constructor for person object.
     */
    public ProductBean ()
    {
    }

    /**
     * Sets the brand of the product.
     * @param brand a string for the product brand.
     */
    public void setBrand (String brand)
    {
        this.brand = brand;
    }

    /**
     * Sets the flag to indicates if the product needs to be reported.
     * @param isActive a boolean flag to indicates if the product needs 
     *                  to be reported.
     */
    public void setEnabled (Boolean enabled)
    {
        this.enabled = enabled;
    }

    /**
     * Sets the minimum quantity of the product requires having before an 
     * order has to be place.
     * @param minLevel an integer for the minimum quantity of the product 
     *                  requires having before an order has to be place.
     */
    public void setMinLevel (Integer minLevel)
    {
        this.minLevel = minLevel;
    }

    /**
     * Sets the name of the product.
     * @param name a string for the name of the product.
     */
    public void setName (String name)
    {
        this.name = name;
    }

    /**
     * Sets the price of ONE product.
     * @param price a double for the price of ONE product.
     */
    public void setPrice (Double price)
    {
        this.price = price;
    }

    /**
     * Sets the product idenification number.
     * @param productNo a string for the product idenification number.
     */
    public void setProductNo (Integer productNo)
    {
        this.productNo = productNo;
    }

    /**
     * Sets the unit amount in ONE product.
     * @param qtyPer an integer for the unit amount in ONE product.
     */
    public void setQtyPer (Integer qtyPer)
    {
        this.qtyPer = qtyPer;
    }

    /**
     * Sets the quantity of the product currently available in inventory.
     * @param stockQty an integer for the quantity of the product currently 
     *                  available in inventory.
     */
    public void setStockQty (Integer stockQty)
    {
        this.stockQty = stockQty;
    }

    /**
     * Sets  the product type.
     * @param type a string for the product type.
     */
    public void setType (String type)
    {
        this.type = type;
    }

    /**
     * Sets the measurement in ONE product.
     * @param unit a string for the measurement in ONE product.
     */
    public void setUnit (String unit)
    {
        this.unit = unit;
    }

    /**
     * Returns the product brand. 
     * @return a string for the product brand.
     */
    public String getBrand ()
    {
        return brand;
    }

    /**
     * Returns a flag to indicates if the product needs to be reported.
     * @return a boolean flag to indicates if the product needs to be reported.
     */
    public Boolean getEnabled ()
    {
        return enabled;
    }

    /**
     * Returns the minimum quantity of the product requires having before an 
     * order has to be place.
     * @return an integer for the minimum quantity of the product requires 
     *                  having before an order has to be place.
     */
    public Integer getMinLevel ()
    {
        return minLevel;
    }

    /**
     * Returns the name of the product.
     * @return a string for the name of the product.
     */
    public String getName ()
    {
        return name;
    }

    /**
     * Returns the price of ONE product.
     * @return a double for the price of ONE product.
     */
    public Double getPrice ()
    {
        return price;
    }

    /**
     * Returns the product idenification number.
     * @return a string for the product idenification number.
     */
    public Integer getProductNo ()
    {
        return productNo;
    }

    /**
     * Returns the unit amount in ONE product.
     * @return an integer for the unit amount in ONE product.
     */
    public Integer getQtyPer ()
    {
        return qtyPer;
    }

    /**
     * Returns the product brand. 
     * @return an integer for the quantity of the product currently available 
     *              in inventory.
     */
    public Integer getStockQty ()
    {
        return stockQty;
    }

    /**
     * Returns the product type. 
     * @return a string for the product type.
     */
    public String getType ()
    {
        return type;
    }

    /**
     * Returns the measurement in ONE product.
     * @return a string for the measurement in ONE product..
     */
    public String getUnit ()
    {
        return unit;
    }
	
	public int compare (Object o1, Object o2)
	{
		ProductBean a1 = (ProductBean)o1;
		ProductBean a2 = (ProductBean)o2;
		
		return a1.getProductNo ().compareTo (a2.getProductNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		ProductBean a = (ProductBean)o;
		
		return (a.getProductNo ().equals (this.getProductNo ()));
	}
}

