/**
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Horace Wan
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
        
package hs.presentation;

import java.util.*;
import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import hs.objects.*;

public class ProductTag extends SimpleTagSupport
{
  private ArrayList productList;

  public void setproductList(ArrayList productList)
  {
    this.productList=productList;
  }

  public void doTag() throws JspException, IOException
  {
    Iterator i = productList.iterator();
    while(i.hasNext())
    {
      ProductBean product = (ProductBean) i.next();
      getJspContext().setAttribute("product", product);
      getJspBody().invoke(null);
    }
  }
}
