public class util_Utilities {
    public static boolean ScheduledRunFlag = false;
    // Builds a CRON Expression out of a Datetime
    public static String GetCRONExpression(Datetime dt) {
       return ('' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
    } 	
}