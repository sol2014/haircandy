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

/**
 * Exception that will occur if an invalid data bean type is attempted on
 * the persistence controller.
 * 
 * @author Philippe Durand
 */
public class BrokerNotFoundException extends Exception
{
    public BrokerNotFoundException(String message)
    {
    }
}
