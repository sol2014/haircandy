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

public class MultithreadedConnection {

	/**
	 * Attributes
	 */
	private Connection connection;
	private Boolean isInUse;
	private String memoryAddress;

	/**
	 * Constructor
	 * 
	 * @param connection
	 */
	public MultithreadedConnection(Connection connection) {
		this.connection = connection;
		this.isInUse = true;// should be used immediately when it is created

		this.memoryAddress = this.connection.toString();
	}

	/**
	 * Getter
	 * 
	 * @return the connection
	 */
	public Connection getConnection() {
		return connection;
	}

	/**
	 * Setter
	 * 
	 * @param connection
	 *            the connection to set
	 */
	public void setConnection(Connection connection) {
		this.connection = connection;
	}

	/**
	 * Getter
	 * 
	 * @return the isInUse
	 */
	public Boolean getIsInUse() {
		return isInUse;
	}

	/**
	 * Setter
	 * 
	 * @param isInUse
	 *            the isInUse to set
	 */
	public void setIsInUse(Boolean isInUse) {
		this.isInUse = isInUse;
	}

	/**
	 * Getter
	 * 
	 * @return the memoryAddress
	 */
	public String getMemoryAddress() {
		return memoryAddress;
	}

	/**
	 * Setter
	 * 
	 * @param memoryAddress
	 *            the memoryAddress to set
	 */
	public void setMemoryAddress(String memoryAddress) {
		this.memoryAddress = memoryAddress;
	}
}
