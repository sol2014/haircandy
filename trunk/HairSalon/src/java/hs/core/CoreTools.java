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

import java.util.*;
import java.io.*;
import java.text.*;

import hs.core.*;
import hs.objects.*;

public class CoreTools {

    public static String display(Object o) {
        if (o == null) {
            return "";
        } else {
            if (o instanceof Date) {
                DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
                return df.format((Date) o);
            } else {
                return o.toString().trim();
            }
        }
    }

    public static String displayMax(String str, int max) {
        String value = "";

        if (str != null) {
            if (str.trim().length() <= max) {
                value = str.trim();
            } else {
                value = str.trim().substring(0, max - 3) + "...";
            }
        }

        return value;
    }

    public static boolean containsOnlyNumbers(String str) {

        //It can't contain only numbers if it's null or empty...
        if (str == null || str.length() == 0) {
            return false;
        }
        for (int i = 0; i < str.length(); i++) {

            //If we find a non-digit character we return false.
            if (!Character.isDigit(str.charAt(i))) {
                return false;
            }
        }

        return true;
    }

    public static String serializeBase64(DataBean bean) {
        try {
            ByteArrayOutputStream os = new ByteArrayOutputStream();
            ObjectOutputStream out = new ObjectOutputStream(os);

            out.writeObject(bean);
            byte[] output = os.toByteArray();
            out.close();

            return Base64.encodeBytes(output);
        } catch (IOException ex) {
            LogController.write("Unable to serialize data bean!");
            ex.printStackTrace();
            return "";
        }
    }

    public static DataBean deserializeBase64(String data) {
        try {
            ByteArrayInputStream os = new ByteArrayInputStream(Base64.decode(data));
            ObjectInputStream in = new ObjectInputStream(os);

            Object object = in.readObject();
            in.close();

            return (DataBean) object;
        } catch (IOException ex) {
            LogController.write("Unable to deserialize data bean! IO Exception!");
            ex.printStackTrace();
            return null;
        } catch (ClassNotFoundException classEx) {
            LogController.write("Unable to deserialize data bean! Class not found!");
            classEx.printStackTrace();
            return null;
        }
    }

    public static boolean isLettersOrNumbers(String text) {
        for (int i = text.length(); i-- > 0;) {
            if (Character.isLetterOrDigit(text.charAt(i))) {
                return false;
            }
        }

        return true;
    }

    public static boolean isNumbers(String text) {
        for (int i = text.length(); i-- > 0;) {
            if (!Character.isDigit(text.charAt(i))) {
                return false;
            }
        }

        return true;
    }

    public static boolean isLetters(String text) {
        for (int i = text.length(); i-- > 0;) {
            if (!Character.isLetter(text.charAt(i))) {
                return false;
            }
        }

        return true;
    }

    public static String displayAlertIcon(String levelstr) {
        AlertLevels level = AlertLevels.valueOf(levelstr);

        switch (level) {
            case Low:
                return "alert-low";
            case Medium:
                return "alert-medium";
            case High:
                return "alert-high";
        }

        return "";
    }

    public static String displayPhoneNumber(String rawNumber) {
        if (rawNumber == null || rawNumber.equals("")) {
            return "No Data";		// First make sure that we have only numbers.

        }
        if (isNumbers(rawNumber)) {
            if (rawNumber.length() == 10) {
                String area = rawNumber.substring(0, 3);
                String first = rawNumber.substring(3, 6);
                String second = rawNumber.substring(6, 10);

                return "(" + area + ") " + first + "-" + second;
            } else {
                return "Bad Length";
            }
        } else {
            return "Not Numeric";
        }
    }

    public static String displayPrice(Double price) {
        return "$ " + price;
    }

    public static String generateTrueFalseOptions(String name, String selected) {
        String html = "";

        if (selected == null || selected.length() < 1) {
            selected = "True";
        }

        html += "<input type=\"radio\" name=\"" + name + "\" value=\"True\" ";

        if (selected != null && selected.toLowerCase().equals("true")) {
            html += "checked=\"checked\"";
        }

        html += "/>True";

        html += "<input type=\"radio\" name=\"" + name + "\" value=\"False\" ";

        if (selected != null && selected.toLowerCase().equals("false")) {
            html += "checked=\"checked\"";
        }

        html += "/>False";

        return html;
    }

    public static String generateOptions(String selected, String[] options) {
        String html = "";

        if (options.length < 1) {
            return "";
        } else {
            for (String option : options) {
                html += "<option value=\"" + option + "\"";

                if (selected != null && selected.toLowerCase().equals(option.toLowerCase())) {
                    html += "selected=\"selected\"";
                }

                html += ">" + option + "</option>";
            }
        }

        return html;
    }

    public static String generateUserRoleOptions(String selected, boolean withNone) {
        String html = "";

        if (withNone) {
            html += "<option value=\"None\"";

            if (selected != null && selected.equals("None")) {
                html += "selected=\"selected\"";
            }

            html += ">None</option>";
        }

        for (UserRoles role : UserRoles.values()) {
            html += "<option value=\"" + role + "\"";

            if (selected != null && selected.toLowerCase().equals(role.toString().toLowerCase())) {
                html += "selected=\"selected\"";
            }

            html += ">" + role + "</option>";
        }
        return html;
    }

    public static String generatePaymentTypeOptions(String selected, boolean withNone) {
        String html = "";

        if (withNone) {
            html += "<option value=\"None\"";

            if (selected != null && selected.equals("None")) {
                html += "selected=\"selected\"";
            }

            html += ">None</option>";
        }

        for (PaymentTypes type : PaymentTypes.values()) {
            html += "<option value=\"" + type + "\"";

            if (selected != null && selected.toLowerCase().equals(type.toString().toLowerCase())) {
                html += "selected=\"selected\"";
            }

            html += ">" + type + "</option>";
        }

        return html;
    }

    public static String generateProductTypeOptions(String selected, boolean withNone) {
        String html = "";

        if (withNone) {
            html += "<option value=\"None\"";

            if (selected != null && selected.equals("None")) {
                html += "selected=\"selected\"";
            }

            html += ">None</option>";
        }

        for (ProductTypes type : ProductTypes.values()) {
            html += "<option value=\"" + type + "\"";

            if (selected != null && selected.toLowerCase().equals(type.toString().toLowerCase())) {
                html += "selected=\"selected\"";
            }

            html += ">" + type + "</option>";
        }

        return html;
    }

    public static String generateProductUnitOptions(String selected, boolean withNone) {
        String html = "";

        if (withNone) {
            html += "<option value=\"None\"";

            if (selected != null && selected.equals("None")) {
                html += "selected=\"selected\"";
            }

            html += ">None</option>";
        }

        for (ProductUnits type : ProductUnits.values()) {
            html += "<option value=\"" + type + "\"";

            if (selected != null && selected.toLowerCase().equals(type.toString().toLowerCase())) {
                html += "selected=\"selected\"";
            }

            html += ">" + type + "</option>";
        }

        return html;
    }

    public static String generateEmployeeExceptions(EmployeeBean employee) {
        String html = "";

        if (employee != null) {
            ArrayList<AvailabilityExceptionBean> exceptions = employee.getAvailabilityExceptions();

            if (exceptions != null) {
                // We have a list of services to display.
                for (AvailabilityExceptionBean exception : exceptions) {
                    html += "<option value=\"" + exception.getDate().toString() + "\">" + exception.getDate().toString() + "</option>";
                }
            }
        }

        return html;
    }

    public static String generateEmployeeServices(EmployeeBean employee) {
        String html = "";

        if (employee != null) {
            ArrayList<ServiceBean> services = employee.getServices();

            if (services != null) {
                // We have a list of services to display.
                for (ServiceBean service : services) {
                    html += "<option value=\"" + service.getServiceNo().toString() + "\">" + service.getName() + "</option>";
                }
            }
        }

        return html;
    }

    public static String generateServicesLeft(EmployeeBean employee, ServiceBean[] services) {
        String html = "";

        if (employee != null && services != null) {
            // We have a list of services to display.
            for (ServiceBean service : services) {
                if (!employee.hasService(service)) {
                    html += "<option value=\"" + service.getServiceNo().toString() + "\">" + service.getName() + "</option>";
                }
            }
        }

        return html;
    }

    public static String showMilitaryTime(Date date) {
        SimpleDateFormat format = new SimpleDateFormat("HH:mm");
        return format.format(date);
    }

    public static int getEndHour(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        if (calendar.get(Calendar.MINUTE) != 0) {
            return calendar.get(Calendar.HOUR_OF_DAY) + 1;
        } else {
            return calendar.get(Calendar.HOUR_OF_DAY);
        }
    }

    public static int getStartHour(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar.get(Calendar.HOUR_OF_DAY);
    }
    
    public static int getHour(Date date)
    {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar.get(Calendar.HOUR_OF_DAY);
    }
    
    public static int getMinutes(Date date)
    {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar.get(Calendar.MINUTE);
    }

    public static int getAMPMHour(int dayHour) {
        if (dayHour == 12) {
            return 12;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.HOUR_OF_DAY, dayHour);
        return calendar.get(Calendar.HOUR);
    }

    public static int getWeekDay(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar.get(Calendar.DAY_OF_WEEK);
    }

    public static String getAMPM(int dayHour) {
        if (dayHour == 12) {
            return "PM";
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.HOUR_OF_DAY, dayHour);
        if (calendar.get(Calendar.AM_PM) == 1) {
            return "PM";
        } else {
            return "AM";
        }
    }
}
