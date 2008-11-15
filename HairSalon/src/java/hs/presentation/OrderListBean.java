package hs.presentation;

import hs.objects.*;

import java.util.*;		//For List and ArrayList
import java.io.*;		//for Serializable
import java.sql.*;		//For Connection, DriverManager, Startement and ResultSet

/**
 * This class impletments the Serializable Interface.
 */
public class OrderListBean implements Serializable
{
	public final int ROW_PER_PAGE = 5;
	
	/* Member Variables */
	private Integer supplierNo;
	//private AddressBean address;
	private ArrayList<ProductBean> products;
	private String name;
	//private String description;
	private String phoneNumber;
    
	
	/* ArrayLists to hold recordsets */
	private List supNoList;
	private List supNameList;
	private List supPhoneList;
	private List productList;
	
	/* Helper Variables */
	private int currentRow;
	private int totalRow;	//Total number of row in the list.
	private int rowCount;	//Total number of row in the list.
	private int currentPage; 
	private int totalPage;  //Total number of page in the report.
	private int prodCount;
	private int supCount;
	
	private Connection db = null;
	
	/* constructor */
	public OrderListBean()
	{
		/* Initialize bean properties */
		setSupplierNo(0);
		setName("");
		setPhoneNumber("");
		products = new ArrayList();
		
		/* Initialize arrayLists to hold recordsets */
		supNoList = new ArrayList();
		supNameList = new ArrayList();
		supPhoneList = new ArrayList();
		productList = new ArrayList();
		
		/* Initialize helper variables */
		currentRow = 0;
		rowCount = 0;
		currentPage = 1;
		prodCount = 0;
		supCount = 0;
		
		/* Get database connection */
		dbConnect();
	}
	
	/* Get Database Connection */
	private void dbConnect()
	{
		if(db == null)
		{
			try{
				Class.forName("org.gjt.mm.mysql.Driver");
				db = DriverManager.getConnection(
						"jdbc:mysql://localhost:3306/catalog2",
						"genUser", "12345");
				
				System.out.println("SysMsg:  DB connect!");
			}
			catch(Exception e)
			{
				System.out.println("Error Connecting to calalog DB: " + e.toString());
			}
		}
	}

	/* Accessor+Getter Methods */
	public ArrayList<ProductBean> getProducts()
	{
		return products;
	}

	public void setProducts(ArrayList<ProductBean> products)
	{
		this.products = products;
	}

	/*
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
	*/
	
	public String getPhoneNumber()
	{
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public Integer getSupplierNo()
	{
		return supplierNo;
	}

	public void setSupplierNo(Integer supplierNo)
	{
		this.supplierNo = supplierNo;
	}

	/* Read-only attribute */
	public int getTotalRow(){
		return totalRow;
	}
	
	public int getCurrentRow(){
		return currentRow;
	}
	
	public int getCurrentPage(){
		return currentPage;
	}
	
	/* Populate Record List */
	public boolean populate()
	{
		ProductBean temp = new ProductBean();
		
		//Varable
		String CurrentSup = "0";
		String PreviousSup = "0";		
		
		System.out.println("SysMsg:  Populating Beginning");
		
		/* If prodIDList is empty, then execute the query to populate it */
		if(supNoList.isEmpty())
		{
			System.out.println("SysMsg:  prodIDList is Empty!");
			
			try
			{
				/* Execute Query */
				Statement s = db.createStatement();
				
				ResultSet rs = s.executeQuery
				("SELECT product_name, brand, product_type, qty_per, "+
						"unit, min_level, stock_qty, price, " + 
						"s.supplier_no, supplier_name, phone_number " +
						"FROM product p, supplier s, supplierproduct sp " +
						"WHERE p.product_no = sp.product_no " +
						"AND sp.supplier_no = s.supplier_no " +
						"AND p.min_level>p.stock_qty AND p.used = false " +
						"ORDER BY s.supplier_no");
				//("SELECT * FROM supplier");
				
				System.out.println("Query Done!");

				//Clear all ArrayList.
				supNoList.clear();
				supNameList.clear();
				supPhoneList.clear();
				productList.clear();
				
				rowCount = 0;

				//Storage each row of data result set to ArrayLists.
				while(rs.next())
				{	
				
					//When there is more then one row, check if the current supplier
					//is the same as the previous supplier.  (Warning!  The query must
					//be ORDER BY supplier number!)
					if(rowCount == 0)
					{
						supNoList.add(rs.getString("s.supplier_no"));
						supNameList.add(rs.getString("supplier_name"));
						supPhoneList.add(rs.getString("phone_number"));
	
						System.out.println("First supplier: " + supNameList.get(supCount));
					}	
					else if(rowCount>0)
					{
						System.out.println("Get next supplier information!");
						
						//Store supplier numbers.
						CurrentSup = rs.getString("s.supplier_no");
						
						PreviousSup = (String) supNoList.get(supCount);
						
						System.out.println("Check if a new supplier shown!");
						
						//If the supplier # is not the same, add the list of product
						//for the previous supplier to ArrayList storage and
						//reset the products ArrayList.
						if(!CurrentSup.equals(PreviousSup))
						{	
							System.out.println("Attempt to store to an arraylist with size " + products.size());
							
							productList.add(products);
							products.clear();
							prodCount = 0;				
						    
							System.out.println("Stored products in arraylist! " + productList.size());
							
							supNoList.add(rs.getString("s.supplier_no"));
							supNameList.add(rs.getString("supplier_name"));
							supPhoneList.add(rs.getString("phone_number"));
							
							System.out.println("New Supplier: " + supNameList.get(supCount));
							
							showProducts(supCount, productList);
							
							supCount++;
							}
					}
					
					//Storage a Product Information in a Product Object.
					temp = new ProductBean ();
					temp.setBrand (rs.getString ("brand"));
					temp.setMinLevel (new Integer(rs.getInt("min_level")));
					temp.setName (rs.getString("product_name"));
					temp.setPrice (new Double(rs.getDouble("price")));
					temp.setQtyPer (new Integer(rs.getString("stock_qty")));
					temp.setType (rs.getString("product_type"));
					temp.setUnit (rs.getString("unit"));
					
					//Add the Product Object to a Product ArrayList.
					products.add(temp);
					
					System.out.println("Create a product!! " + products.get(prodCount).getName());
					
					prodCount++;
					
					System.out.println("Stored a product!");
					
					rowCount++;
				}

				System.out.println("Attempt to store to an arraylist with size " + products.size());
				
				//Add the product information to the ArrayList storage
				//for the last supplier.
				productList.add(products);
				products.clear();
				prodCount = 0;

				showProducts(supCount, productList);
				
				System.out.println("Stored products in arraylist! " + productList.size());
				
				rowCount = supCount;
				totalRow = rowCount;
				
				if(totalPage==0)
				{
					setCurrentPage(totalPage);
				}
			}
			catch(Exception e)
			{
				System.out.println("Error populating OrderListBean: " + e.toString());
				return false;
			}
		}
		
		/* Return status of operation */
		return true;
	}
	
	/* Reset current row */
	public void setStartRow(int _start)
	{
		if(_start<rowCount)
		{
			currentRow = _start;
		}
	}
	
	/* Calculate the total number of page in the report */ 
	public int getTotalPage()
	{
		int remainder = totalRow%ROW_PER_PAGE;
		totalPage = totalRow/ROW_PER_PAGE;
		
		if(remainder>0)
		{
			return (totalPage+1);
		}
		else
		{
			return totalPage;
		}
	}

	/* Calculate the current page number in the report */ 
	public void setCurrentPage(int _currentRow)
	{
		int remainder = _currentRow%ROW_PER_PAGE;
		currentPage = _currentRow/ROW_PER_PAGE;
		
		if(remainder>0&&currentPage>0)
		{
			currentPage += 1;
		}
		
		if(totalPage==0||totalPage==1)
		{
			currentPage = 1;
		}
	}
	
	/* Move to next row */
	@SuppressWarnings("unchecked")
	public int nextRow()
	{
		ProductBean temp = new ProductBean();
		System.out.println("Attempt to display a row.");
		System.out.println("currentRow="+currentRow+" rowCount="+rowCount);
		
		if(currentRow == rowCount)
		{
			currentRow = 0;  //Reset for next page request.
			return 0;  //Return 0 to indicate end of record set.
		}
		
		/* Populate bean properties with current row */
		Integer supNo = Integer.parseInt((String) supNoList.get(currentRow));
		setSupplierNo(supNo.intValue());
		
		setName((String)supNameList.get(currentRow));
		
		setPhoneNumber((String)supPhoneList.get(currentRow));
		
		System.out.println("Supplier name: " + getName());
		
		setProducts((ArrayList<ProductBean>) productList.get(currentRow));
		
		/*
	    Iterator i = getProducts().iterator();
	    
	    while(i.hasNext())
	    {
	    	System.out.println("Display Product!");
	    	ProductBean product = (ProductBean) i.next();
			System.out.println("Product Name (i): " + product.getName());
	    }
	    */

		//temp = new ProductBean((ProductBean)productList.get(currentRow));
		
		//setProducts(null);
		
		//System.out.println("Product name: " + temp.getName());
		//System.out.println("Product price: $" + temp.getPrice());
		
		setCurrentPage(currentRow);
		
		currentRow++;
				
		System.out.println("One Row Displayed.");
		
		/* return currentRow */
		return currentRow;
	}
	
	public void showProducts(int count, List productList)
	{
		int counter=0;
		
		System.out.println("Product List = "+productList.size());
		
		products.clear();
		
		Iterator i = productList.iterator();
		
		while(i.hasNext())
		{
			counter++;
			products = ((ArrayList<ProductBean>) i.next());
		}
		
		System.out.println("Counter = " + counter + " Products = "+products.size());
		
		/*
		Iterator i = productList.iterator();
		
		while(i.hasNext())
		{
			ArrayList products = (ArrayList<ProductBean>) i.next();
		}
		
		//setProducts((ArrayList<ProductBean>) productList.get(count));
		
	    Iterator j = getProducts().iterator();
	    
	    System.out.println("Attempt to show the product list. Size="+products.size());
	    
	    while(i.hasNext())
	    {
	    	System.out.println("Display Product!");
	    	ProductBean product = (ProductBean) j.next();
			System.out.println("Product Name (i): " + product.getName());
	    }
	    */
	}
}