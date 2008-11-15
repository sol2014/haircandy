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
