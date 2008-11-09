/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.core;

/**
 * These are the different positions the session can be in. These positions
 * can also be stacked together in a sequence.
 * 
 * @author Philippe Durand
 */
public enum SessionPositions
{
	None,
	
	// Primary Level Positions
	Login,
	Help,
	GuestWelcome,
	
	EmployeeWelcome,
	Availability,
	Sales,
	SchCalendar,
	AppCalendar,
	SchScheduler,
	AppScheduler,
	Salon,
	Employees,
	Products,
	Clients,
	Suppliers,
	Services,
	Reports,
	
	// Secondary Level Positions
	CreateSale,
	
	CreateService,
	CreateEmployee,
	CreateProduct,
	CreateClient,
	CreateSupplier,
	
	MaintainService,
	MaintainEmployee,
	MaintainProduct,
	MaintainClient,
	MaintainSupplier,
    MaintainSale,
}
