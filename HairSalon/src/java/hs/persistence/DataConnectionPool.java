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

import java.sql.*;
import java.util.*;

import hs.core.*;

/**
 * Creates and manages database connections, distributing them as required.
 * 
 * @author Philippe Durand
 */
public class DataConnectionPool
{
	private static DataConnectionPool instance = null;
	
	public static DataConnectionPool getInstance ()
	{
		if (instance == null)
		{
			instance = new DataConnectionPool ();
		}
		
		return instance;
	}
	
    private Vector<Connection> usedConnections;
    private Vector<Connection> unusedConnections;
    private String url,  user,  password;
    final private long timeout = 60000;
    final private int poolsize = 10;
	
	DataConnectionPool ()
	{
		
	}
	
    public void initialize (String url, String user, String password)
        throws ClassNotFoundException, InstantiationException, IllegalAccessException, SQLException
    {
        this.url = url;
        this.user = user;
        this.password = password;

        unusedConnections = new Vector<Connection>();
        usedConnections = new Vector<Connection>();

        Class.forName("com.mysql.jdbc.Driver");

        for (int i = 0; i < poolsize; i++)
        {
            unusedConnections.add(DriverManager.getConnection(url, user, password));
        }
    }
	
	public synchronized void destroy ()
	{
		closeConnections ();
		
		usedConnections = null;
		unusedConnections = null;
	}
	
    public synchronized void cleanConnections()
    {
        long stale = System.currentTimeMillis() - timeout;
        Enumeration list = usedConnections.elements();
		
        while ((list != null) && (list.hasMoreElements()))
        {
            Connection conn = (Connection) list.nextElement();
			
            try
            {
                conn.getMetaData();
            }
            catch (Exception e)
            {
                removeConnection(conn, usedConnections);
            }
        }
    }
	
    public synchronized void closeConnections()
    {
        Enumeration list = usedConnections.elements();
		
        while ((list != null) && (list.hasMoreElements()))
        {
            removeConnection((Connection) list.nextElement(), usedConnections);
        }
		
		list = unusedConnections.elements ();
		
		while ((list != null) && (list.hasMoreElements ()))
		{
			removeConnection((Connection) list.nextElement (), unusedConnections);
		}
    }
	
    private synchronized void removeConnection(Connection conn, Vector<Connection> connections)
    {
        try
        {
            if (!conn.isClosed())
            {
                conn.close();
            }
        }
        catch (SQLException e)
        {
            // Unable to close the connection.
        }
        finally
        {
            connections.removeElement(conn);
        }
    }

    public synchronized Connection getConnection() throws SQLException
    {
        Connection conn;

        // First we want to see if there is a connection available for us to use.
        if (unusedConnections.isEmpty())
        {
			LogController.write (this, "DB: Creating new connection: "+unusedConnections.size ()+" open connections.");
			
            // We have no unused connections left, make a new one. This is where
            // we would take a performance hit. Perhaps our initial number is too low?
            conn = DriverManager.getConnection(url, user, password);
        }
        else
        {
            conn = unusedConnections.remove(0);
        }
		
        usedConnections.add(conn);
		
        return conn;
    }

    public synchronized void returnConnection(Connection conn)
    {
		if (conn != null)
		{
			usedConnections.remove(conn);
			unusedConnections.add(conn);
		}
    }
}
