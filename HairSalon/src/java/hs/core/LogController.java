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

import java.io.*;
import java.util.Date;

/**
 * The logging facility used by the web application. It allows minor flexibility
 * to the logging of the application in case console output is not preferred.
 * Some formatting is also adopted to give the output more direction as to
 * what is happening in the application and when it has happened.
 * @author Philippe Durand
 */
public class LogController
{
    private static FileOutputStream fileStream;
    private static PrintStream printStream;

    /**
     * Initializes the log handler with the application context.
     * @param ctx the application context used to log information
     */
    public static void initialize ()
    {
        try
        {
            fileStream = new FileOutputStream ("AppLog.txt");
            printStream = new PrintStream (fileStream);
        }
		catch (IOException ioe)
        {
            write ("Logger: Error initializing the output stream");
        }

        write ("HairSalon v1.0 - Scheduling & Management System");
        write ("--------------------------------------------------------------------");
        write ("Logger->Initialized.");
    }

    /**
     * Writes a string to the available output methods.
     * @param text the text to be written to the output
     */
    public static void write (String text)
    {
        write (null, text);
    }

    /**
     * Writes a string to the available output using a class name description.
     * @param obj the object this call is happening for
     * @param text the text to be written to the output
     */
    public static void write (Object obj, String text)
    {
        String output = new Date (System.currentTimeMillis ()).toString ();

        if (obj == null)
        {
            output += ": " + text;
        } else
        {
            output += ": " + obj.getClass ().getSimpleName () + "->" + text;
        }

        if (printStream != null)
        {
            printStream.println (output);
        }

        System.out.println (output);
    }

    /**
     * Destroys the log handler.
     */
    public static void shutdown ()
    {
        if (printStream != null)
        {
            printStream.close ();
        }
    }
}
