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
import java.util.*;

public class MultithreadedCleaner implements Runnable {
/**
	 * Attributes
	 */
	private Hashtable<String, MultithreadedConnection> pool;
	private int connectionsInUse;

	/**
	 * Constructor
	 * 
	 * @param pool
	 */
	public MultithreadedCleaner(Hashtable<String, MultithreadedConnection> pool) {
		this.pool = pool;
	}

	/**
	 * Increase the number of connections in use
	 */
	public void increaseConnectionsInUse() {
		this.connectionsInUse++;
	}

	/**
	 * Decrease the number of connections in use
	 */
	public void decreaseConnectionsInUse() {
		this.connectionsInUse--;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	public void run() {
		try {
			while (true) {
				synchronized (pool) {
					if (pool.size() > 10) {
						if (connectionsInUse * 100 / pool.size() < 66) {
							Enumeration<String> connections = pool.keys();
							String key = null;
							MultithreadedConnection jc = null;
							Boolean isRemovable = false;
							while (connections.hasMoreElements()) {
								key = connections.nextElement();
								jc = pool.get(key);
								if (!jc.getIsInUse()) {
									isRemovable = true;
									break;
								}
							}
							if (isRemovable) {
								try {
									jc.getConnection().close();
								} catch (Exception e) {
								}
								pool.remove(key);
							}
						}
					}
				}
				Thread.sleep(20000);
			}
		} catch (Exception e) {
		}
	}
}
