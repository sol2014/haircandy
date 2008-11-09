/*
 * HairSalon: Scheduling and Management System
 * Systems II - Southern Alberta Institute of Technology
 * 
 * File Author: Philippe Durand
 * 
 * System Developed by:
 * Joey Ren, Philippe Durand, Miyoung Han, Horace Wan and Nuha Bazara
 */

package hs.presentation;

import hs.core.*;
import java.io.IOException;
import java.util.Enumeration;
import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;

/**
 * Filter used to ensure that all input and output is converted and used only 
 * as text within the data that is used within the requests. Filters out HTML 
 * tagging.
 * 
 * @author Horace Wan
 */
public class RequestFilter implements javax.servlet.Filter
{
    public void init (FilterConfig filterConfig)
    {
            LogController.write (this, "Created.");
    }

    /**
     * Performs the filter operation to facilitate chain filtering and both input
     * and output is used.
     * @param request The servlet request going through the filter.
     * @param response The servlet response going through the filter.
     * @param chain The filter chain used.
     * @throws java.io.IOException
     * @throws javax.servlet.ServletException
     */
    public void doFilter (ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException
    {
            inbound (request, response);
            disableBrowserCache (request, response);

            chain.doFilter (request, response);

            outbound (request, response);
    }

    private void inbound (ServletRequest request, ServletResponse response)
            throws ServletException, IOException
    {
            Enumeration names = request.getParameterNames ();

            while (names.hasMoreElements ())
            {
                    String name = (String) names.nextElement ();
                    String value = request.getParameter (name).toString ();

                    request.setAttribute ("filtered_", value);
            }
    }

    private void disableBrowserCache (ServletRequest request, ServletResponse response)
            throws ServletException, IOException
    {
            ((HttpServletResponse) response).setHeader ("Cache-Control", "max-age=0, must-revalidate, no-cache, no-store, private");
            ((HttpServletResponse) response).setHeader ("Pragma", "no-cache");
            ((HttpServletResponse) response).setDateHeader ("Expires", -1);
    }

    private void outbound (ServletRequest request, ServletResponse response)
    {
            // No outbound filtering right now.
    }

    /**
     * Destroys the request filter object.
     */
    public void destroy ()
    {
            LogController.write (this, "Destroyed.");
    }
}
