/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Joey Ren
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */
package hs.objects;

import java.util.*;

public class EmployeeLastNameComparator implements Comparator<EmployeeBean> {

	public int compare(EmployeeBean eb1, EmployeeBean eb2) {
		return eb1.getLastName().compareTo(eb2.getLastName());
	}
}
