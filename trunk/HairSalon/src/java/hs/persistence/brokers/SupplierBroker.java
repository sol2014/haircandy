/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.persistence.brokers;

import java.sql.*;
import java.util.*;

import hs.core.*;
import hs.objects.*;
import hs.persistence.*;

/**
 * 
 * @author Nuha Bazara
 */
public class SupplierBroker extends DatabaseBroker implements BrokerInterface
{
	private static SupplierBroker instance = null;

	public static SupplierBroker getInstance ()
	{
		if (instance == null)
		{
			instance = new SupplierBroker ();
		}

		return instance;
	}

	SupplierBroker ()
	{
	}

	@Override
	public DataBean[] search (DataBean data)
	{
		SupplierBean supplier = (SupplierBean) data;
		AddressBean address = supplier.getAddress ();

		ArrayList<SupplierBean> supplierAL = new ArrayList<SupplierBean> ();

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call SearchSupplier(?,?,?,?,?,?,?,?,?,?,?)}");
			int index = 1;

			addToStatement (proc, address.getAddress1 (), index++, String.class);
			addToStatement (proc, address.getAddress2 (), index++, String.class);
			addToStatement (proc, address.getCity (), index++, String.class);
			addToStatement (proc, address.getProvince (), index++, String.class);
			addToStatement (proc, address.getCountry (), index++, String.class);
			addToStatement (proc, address.getPostalCode (), index++, String.class);
			addToStatement (proc, address.getEmail (), index++, String.class);
			addToStatement (proc, supplier.getName (), index++, String.class);
			addToStatement (proc, supplier.getDescription (), index++, String.class);
			addToStatement (proc, supplier.getPhoneNumber (), index++, String.class);
			addToStatement (proc, supplier.getEnabled (), index++, Boolean.class);

			ResultSet result = proc.executeQuery ();
			while (result.next ())
			{
				supplierAL.add ((SupplierBean) getBean (result));
			}
			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Found supplier beans: "+supplierAL.size());
		
		SupplierBean[] supplierA = new SupplierBean[supplierAL.size ()];
		return supplierAL.toArray (supplierA);
	}

	@Override
	public boolean commit (DataBean data)
	{
		SupplierBean supplier = (SupplierBean) data;
		boolean result = false;
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc;
			int index = 1;
			
			if (supplier.getSupplierNo () == null)
			{
				proc = connection.prepareCall ("{call CreateSupplier(?,?,?,?,?,?)}");
			}
			else
			{
				proc = connection.prepareCall ("{call UpdateSupplier(?,?,?,?,?,?)}");
				proc.setInt (index++, supplier.getSupplierNo());
			}
			
			AddressBean address = supplier.getAddress ();
			AddressBroker.getInstance ().commit (address);
			
			proc.setInt (index++, address.getAddressNo ());
			
			if (supplier.getName () == null)
			{
				proc.setNull (index++, java.sql.Types.VARCHAR);
			}
			else
			{
				proc.setString (index++, supplier.getName ());
			}
			
			if (supplier.getDescription () == null)
			{
				proc.setNull (index++, java.sql.Types.VARCHAR);
			}
			else
			{
				proc.setString (index++, supplier.getDescription ());
			}
			
			if (supplier.getPhoneNumber () == null)
			{
				proc.setNull (index++, java.sql.Types.VARCHAR);
			}
			else
			{
				proc.setString (index++, supplier.getPhoneNumber ());
			}
			
			proc.setBoolean (index++, supplier.getEnabled ());
			
			if (supplier.getSupplierNo () == null)
			{
				proc.registerOutParameter ("p_supplier_no", Types.INTEGER);
				proc.executeUpdate ();
				supplier.setSupplierNo (proc.getInt ("p_supplier_no"));
			}
			else
			{
				proc.executeUpdate ();
			}
			
			result = deleteProducts (supplier);
			if (!result)
			{
				LogController.write (this, "Unable to delete products: "+supplier.getSupplierNo());
				return false;
			}
			for (ProductBean pb : supplier.getProducts ())
			{
				result = addProduct (supplier, pb);
				if (!result)
				{
					LogController.write (this, "Unable to add product to: "+supplier.getSupplierNo());
					return false;
				}
			}
			super.returnConnection (connection);
			
			LogController.write (this, "Commit supplier bean: "+supplier.getSupplierNo ());
			
			return true;
		}
		catch (SQLException e)
		{
			LogController.write (this, "SQL Exception: "+e.toString());
			e.printStackTrace();
			
			return false;
		}

	}

	private boolean deleteProducts (SupplierBean sb)
	{
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call DeleteSupplierProducts(?)}");
			proc.setInt (1, sb.getSupplierNo ());
			proc.execute ();
			super.returnConnection (connection);
			return true;
		}
		catch (Exception e)
		{
			return false;
		}
	}

	private boolean addProduct (SupplierBean sb, ProductBean pb)
	{
		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call AddSupplierProduct(?,?)}");
			proc.setInt (1, sb.getSupplierNo ());
			proc.setInt (2, pb.getProductNo ());
			proc.execute ();
			super.returnConnection (connection);
			return true;
		}
		catch (Exception e)
		{
			return false;
		}
	}

	@Override
	public boolean delete (DataBean data)
	{
		SupplierBean supplier = (SupplierBean) data;

		try
		{
			if (supplier.getSupplierNo () != null)
			{
				Connection connection = super.getConnection ();
				CallableStatement proc = connection.prepareCall ("{call DeleteSupplier(?)}");

				proc.setInt (1, supplier.getSupplierNo ());

				boolean result = proc.execute ();

				super.returnConnection (connection);

				return result;
			}
			else
			{
				return false;
			}

		}
		catch (SQLException e)
		{
			return false;
		}
	}

	@Override
	public boolean exists (DataBean data)
	{
		throw new UnsupportedOperationException ("Not supported yet.");
	}

	@Override
	public DataBean getBean (ResultSet result) throws SQLException
	{
		SupplierBean supplier = new SupplierBean ();
		supplier.setSupplierNo (result.getInt ("supplier_no"));
		supplier.setName (result.getString ("supplier_name"));
		supplier.setDescription (result.getString ("description"));
		supplier.setPhoneNumber (result.getString ("phone_number"));
		supplier.setEnabled (result.getBoolean ("enabled"));

		supplier.setLoaded ();

		AddressBean address = new AddressBean ();
		address.setAddressNo (result.getInt ("address_no"));
		supplier.setAddress ((AddressBean) PersistenceController.load (address));
		return supplier;
	}

	@Override
	public DataBean load (DataBean data)
	{
		SupplierBean supplier = (SupplierBean) data;
		ArrayList<ProductBean> products = new ArrayList<ProductBean> ();

		try
		{
			Connection connection = super.getConnection ();
			CallableStatement proc = connection.prepareCall ("{call LoadSupplier(?)}");

			// Check which search parameters this object provides

			if (supplier.getSupplierNo () != null)
			{
				proc.setInt (1, supplier.getSupplierNo ());
			}
			else
			{
				LogController.write (this, "Employee bean has no identification number!");
				return null;
			}

			// The first result set should be the record.
			ResultSet result = proc.executeQuery ();

			if (result.next ())
			{
				supplier = (SupplierBean) getBean (result);
			}
			else
			{
				LogController.write (this, "There were no results for this load! Employee not loaded.");
				return null;
			}

			if (proc.getMoreResults ())
			{
				ResultSet productResults = proc.getResultSet ();
				while (productResults.next ())
				{
					ProductBean pb = (ProductBean) (ProductBroker.getInstance ().getBean (productResults));
					products.add (pb);
				}
			}
			supplier.setProducts (products);

			super.returnConnection (connection);
		}
		catch (SQLException sqlEx)
		{
			LogController.write (this, "SQL Exception during search: " + sqlEx.getMessage ());
		}
		
		LogController.write (this, "Loaded supplier bean: "+supplier.getSupplierNo ());

		return supplier;
	}
}
