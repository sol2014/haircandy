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
 * This bean holds information about products that are sold, or consumed by
 * services during appointments.
 * 
 * @author Horace Wan
 */
public class ProductBean extends DataBean implements Comparable
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
     * The quantity of units the product currently available in inventory.
     */
    private Integer stockQty;
    /**
     * The minimum quantity level before alerting employees.
     */
    private Integer minLevel;
    /**
     * The price of one whole product.
     */
    private Double price;
    /**
     * The measurement in ONE product.
     */
    private String unit;
    /**
     * The flag used to enable or disable this product in the system.
     */
    private boolean enabled = true;
    /**
     * The number of units in one product.
     */
    private Integer qtyPer;

    /**
     *  Default constructor for the product object.
     */
    public ProductBean ()
    {
		
    }
	
	/**
	 * Clones the information of the passed bean into this one.
	 * 
	 * @param bean the bean information to clone.
	 */
	public void clone (ProductBean bean)
	{
		this.setBrand (bean.getBrand ());
		this.setEnabled (bean.getEnabled());
		this.setMinLevel (bean.getMinLevel());
		this.setName (bean.getName ());
		this.setPrice (bean.getPrice());
		this.setProductNo (bean.getProductNo ());
		this.setQtyPer (bean.getQtyPer ());
		this.setStockQty (bean.getStockQty ());
		this.setType (bean.getType ());
		this.setUnit (bean.getUnit ());
	}
	
    public void setBrand (String brand)
    {
        this.brand = brand;
    }

    public void setEnabled (Boolean enabled)
    {
        this.enabled = enabled;
    }

    public void setMinLevel (Integer minLevel)
    {
        this.minLevel = minLevel;
    }

    public void setName (String name)
    {
        this.name = name;
    }

    public void setPrice (Double price)
    {
        this.price = price;
    }

    public void setProductNo (Integer productNo)
    {
        this.productNo = productNo;
    }

    public void setQtyPer (Integer qtyPer)
    {
        this.qtyPer = qtyPer;
    }

    public void setStockQty (Integer stockQty)
    {
        this.stockQty = stockQty;
    }

    public void setType (String type)
    {
        this.type = type;
    }

    public void setUnit (String unit)
    {
        this.unit = unit;
    }

    public String getBrand ()
    {
        return brand;
    }

    public Boolean getEnabled ()
    {
        return enabled;
    }

    public Integer getMinLevel ()
    {
        return minLevel;
    }

    public String getName ()
    {
        return name;
    }

    public Double getPrice ()
    {
        return price;
    }

    public Integer getProductNo ()
    {
        return productNo;
    }

    public Integer getQtyPer ()
    {
        return qtyPer;
    }

    public Integer getStockQty ()
    {
        return stockQty;
    }

    public String getType ()
    {
        return type;
    }

    public String getUnit ()
    {
        return unit;
    }
	
	public int compareTo (Object o)
	{
		ProductBean a = (ProductBean)o;
		
		return getProductNo ().compareTo (a.getProductNo ());
	}
	
	@Override
	public boolean equals (Object o)
	{
		ProductBean a = (ProductBean)o;
		
		return (a.getProductNo ().equals (this.getProductNo ()));
	}

	@Override
	public int hashCode ()
	{
		int hash = 7;
		hash = 89 * hash + (this.productNo != null ? this.productNo.hashCode () : 0);
		return hash;
	}
}

