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

import hs.objects.*;

/**
 * Defines how the persistence brokers should deal with the data beans.
 * 
 * @author Philippe Durand
 */
public interface BrokerInterface
{
	DataBean[] search (DataBean data);

	DataBean load (DataBean data);

	boolean commit (DataBean data);

	boolean exists (DataBean data);

	boolean delete (DataBean data);

	DataBean getBean (ResultSet set) throws SQLException;
}
