/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.persistence;

import java.sql.*;
import java.util.*;

public class MultithreadedJDBCConnectionPool {

	/**
	 * Attributes
	 */
	private static MultithreadedJDBCConnectionPool singletenInstance;
	private MultithreadedDealer jcd;

	/**
	 * Singleton pattern to get pool
	 * 
	 * @param driver
	 * @param server
	 * @param user
	 * @param password
	 * @return
	 */
	public static MultithreadedJDBCConnectionPool getConnectionPool(String driver,
			String server, String user, String password) {
		if (singletenInstance == null) {
			singletenInstance = new MultithreadedJDBCConnectionPool(driver, server,
					user, password);
		}
		return singletenInstance;
	}

	/**
	 * Method returns the instance that has been created
	 * 
	 * @return
	 */
	public static MultithreadedJDBCConnectionPool getConnectionPool() {
		return singletenInstance;
	}

	/**
	 * Constructor
	 * 
	 * @param driver
	 * @param server
	 * @param user
	 * @param password
	 */
	private MultithreadedJDBCConnectionPool(String driver, String server, String user,
			String password) {
		Hashtable<String, MultithreadedConnection> pool = new Hashtable<String, MultithreadedConnection>();
		MultithreadedCleaner jcc = new MultithreadedCleaner(pool);
		MultithreadedDealer jcd = new MultithreadedDealer(pool, driver,
				server, user, password, jcc);
		this.jcd = jcd;
		(new Thread(jcc)).start();
	}

	/**
	 * Method that returns a connection to the requester
	 * 
	 * @return
	 * @throws SQLException
	 */
	public Connection getConnection() throws SQLException, ClassNotFoundException, InstantiationException, IllegalAccessException {
		Connection connection = this.jcd.getConnection();
		return connection;
	}

	/**
	 * Method that returns a connection to the pool
	 * 
	 * @param connection
	 */
	public void returnConnection(Connection connection) {
		this.jcd.returnConnection(connection);
	}
}
