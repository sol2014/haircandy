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

public class MultithreadedDealer {

	/**
	 * Attributes
	 */
	private Hashtable<String, MultithreadedConnection> pool;
	private String driver;
	private String server;
	private String user;
	private String password;
	private MultithreadedCleaner jcc;

	/**
	 * Constructor
	 * 
	 * @param pool
	 * @param driver
	 * @param server
	 * @param user
	 * @param password
	 * @param jcc
	 */
	public MultithreadedDealer(Hashtable<String, MultithreadedConnection> pool,
			String driver, String server, String user, String password,
			MultithreadedCleaner jcc) {
		this.pool = pool;
		this.driver = driver;
		this.server = server;
		this.user = user;
		this.password = password;
		this.jcc = jcc;
	}

	/**
	 * Method that creates new connection
	 * 
	 * @return
	 */
	private Connection createConnection() throws ClassNotFoundException, SQLException, InstantiationException, IllegalAccessException {
		Class.forName(this.driver).newInstance();
			Connection connection = DriverManager.getConnection(this.server,
					this.user, this.password);
			MultithreadedConnection jc = new MultithreadedConnection(connection);
			synchronized (pool) {
				this.pool.put(jc.getMemoryAddress(), jc);
				this.jcc.increaseConnectionsInUse();
			}
			return connection;
	}

	/**
	 * Methods that give available connection to requester
	 * 
	 * @return
	 */
	public Connection getConnection() throws ClassNotFoundException, SQLException, InstantiationException, IllegalAccessException {
		Connection connection = null;
		synchronized (pool) {
			ArrayList<String> brokenKeys = new ArrayList<String>();
			connection = check(pool, brokenKeys);
			for (String key : brokenKeys) {
				MultithreadedConnection jc = pool.get(key);
				try {
					jc.getConnection().close();
				} catch (SQLException sqle) {
				}
				pool.remove(key);
			}
		}
		if (connection == null) {
			return createConnection();
		} else {
			return connection;
		}
	}

	/**
	 * Method that check connections
	 * 
	 * @param pool
	 * @param brokenKeys
	 * @return
	 */
	private Connection check(Hashtable<String, MultithreadedConnection> pool,
			ArrayList<String> brokenKeys) {
		Enumeration<String> keys = pool.keys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			MultithreadedConnection jc = pool.get(key);
			if (!jc.getIsInUse()) {
				try {
					jc.getConnection().createStatement();
					if (jc.getConnection().isClosed()) {
						throw new SQLException();
					}
					jc.setIsInUse(true);
					this.jcc.increaseConnectionsInUse();
					return jc.getConnection();
				} catch (Exception e) {
					brokenKeys.add(key);
				}
			}
		}
		return null;
	}

	/**
	 * Method that return connection back to the pool
	 * 
	 * @param connection
	 */
	public void returnConnection(Connection connection) {
		synchronized (pool) {
			MultithreadedConnection jc = pool.get(connection.toString());
			if (jc != null) {
				try {
					connection.createStatement();
					if (connection.isClosed()) {
						throw new SQLException();
					}
					jc.setIsInUse(false);
				} catch (Exception e) {
					try {
						connection.close();
					} catch (SQLException e1) {
					}
					pool.remove(jc);
				}
				this.jcc.decreaseConnectionsInUse();
			}
		}
	}
}
