/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.persistence;

import hs.core.LogController;
import hs.objects.*;
import java.sql.*;

/**
 * This is the abstract broker that will access our database connection
 * for all broker types.
 * 
 * @author Philippe Durand
 */
public abstract class DatabaseBroker implements BrokerInterface
{
	//protected DataConnectionPool connectionPool;
	protected MultithreadedJDBCConnectionPool connectionPool;

	public DatabaseBroker ()
	{
		//connectionPool = DataConnectionPool.getInstance ();
		connectionPool = MultithreadedJDBCConnectionPool.getConnectionPool ();
	}

	protected Connection getConnection () throws SQLException
	{
		return connectionPool.getConnection ();
	}

	protected void returnConnection (Connection connection)
	{
		connectionPool.returnConnection (connection);
	}

	public abstract DataBean load (DataBean data);

	public abstract DataBean[] search (DataBean data);

	public abstract boolean commit (DataBean data);

	public abstract boolean delete (DataBean data);

	public abstract boolean exists (DataBean data);

	public abstract DataBean getBean (ResultSet set) throws SQLException;

	public void addToStatement (CallableStatement statement, Object object, int index, Class type)
			throws SQLException
	{
		int sqlType = getSqlType (type, object);

		if (object == null)
		{
			statement.setNull (index, sqlType);
		}
		else
		{
			switch (sqlType)
			{
				case java.sql.Types.BOOLEAN:
					statement.setBoolean (index, (Boolean) object);
					break;
				case java.sql.Types.CHAR:
				case java.sql.Types.VARCHAR:
					statement.setString (index, (String) object);
					break;
				case java.sql.Types.DATE:
					statement.setDate (index, (java.sql.Date) object);
					break;
				case java.sql.Types.TIME:
					statement.setTime (index, (java.sql.Time) object);
					break;
				case java.sql.Types.DOUBLE:
				case java.sql.Types.DECIMAL:
					statement.setDouble (index, (Double) object);
					break;
				case java.sql.Types.BIGINT:
				case java.sql.Types.SMALLINT:
				case java.sql.Types.TINYINT:
				case java.sql.Types.INTEGER:
					statement.setInt (index, (Integer) object);
					break;
				default:
					LogController.write (this, "Unable to determine the SQL Type: " + sqlType);
					break;
			}
		}
	}

	private int getSqlType (Class type, Object object)
	{
		int sqlType = java.sql.Types.NULL;

		if (type == Boolean.class)
		{
			return java.sql.Types.BOOLEAN;
		}
		if (type == Integer.class)
		{
			return java.sql.Types.INTEGER;
		}
		if (type == Double.class)
		{
			return java.sql.Types.DOUBLE;
		}
		if (type == String.class)
		{
			return java.sql.Types.VARCHAR;
		}
		if (type == Date.class)
		{
			return java.sql.Types.DATE;
		}
		if (type == Time.class)
		{
			return java.sql.Types.TIME;
		}
		return sqlType;
	}
}
