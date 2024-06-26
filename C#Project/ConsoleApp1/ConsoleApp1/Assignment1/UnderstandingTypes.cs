namespace ConsoleApp1.Assignment1;

public class UnderstandingTypes {
    public static void Main()
    {
        num_of_bytes();
        convertTime();
    }

    private static void num_of_bytes()
    {
            Console.WriteLine($"The number of bytes of sbyte in memory is {sizeof(sbyte)}");
            Console.WriteLine($"The maximum value of sbyte is {int.MaxValue}");
            Console.WriteLine($"The minimum value of sbyte is {int.MinValue}");
            Console.WriteLine($"The number of bytes of byte in memory is {sizeof(byte)}");
            Console.WriteLine($"The maximum value of byte is {byte.MaxValue}");
            Console.WriteLine($"The minimum value of byte is {byte.MinValue}");
            Console.WriteLine($"The number of bytes of short in memory is {sizeof(short)}");
            Console.WriteLine($"The maximum value of short is {short.MaxValue}");
            Console.WriteLine($"The minimum value of short is {short.MinValue}");
            Console.WriteLine($"The number of bytes of ushort in memory is {sizeof(ushort)}");
            Console.WriteLine($"The maximum value of ushort is {ushort.MaxValue}");
            Console.WriteLine($"The minimum value of ushort is {ushort.MinValue}");
            Console.WriteLine($"The number of bytes of int in memory is {sizeof(int)}");
            Console.WriteLine($"The maximum value of int is {int.MaxValue}");
            Console.WriteLine($"The minimum value of int is {int.MinValue}");
            Console.WriteLine($"The number of bytes of uint in memory is {sizeof(uint)}");
            Console.WriteLine($"The maximum value of uint is {uint.MaxValue}");
            Console.WriteLine($"The minimum value of uint is {uint.MinValue}");
            Console.WriteLine($"The number of bytes of long in memory is {sizeof(long)}");
            Console.WriteLine($"The maximum value of long is {long.MaxValue}");
            Console.WriteLine($"The minimum value of long is {long.MinValue}");
            Console.WriteLine($"The number of bytes of ulong in memory is {sizeof(ulong)}");
            Console.WriteLine($"The maximum value of ulong is {ulong.MaxValue}");
            Console.WriteLine($"The minimum value of ulong is {ulong.MinValue}");
            Console.WriteLine($"The number of bytes of float in memory is {sizeof(float)}");
            Console.WriteLine($"The maximum value of float is {float.MaxValue}");
            Console.WriteLine($"The minimum value of float is {float.MinValue}");
            Console.WriteLine($"The number of bytes of double in memory is {sizeof(double)}");
            Console.WriteLine($"The maximum value of double is {double.MaxValue}");
            Console.WriteLine($"The minimum value of double is {double.MinValue}");
            Console.WriteLine($"The number of bytes of decimal in memory is {sizeof(decimal)}");
            Console.WriteLine($"The maximum value of decimal is {decimal.MaxValue}");
            Console.WriteLine($"The minimum value of decimal is {decimal.MinValue}");
    }


    public static void convertTime()
    {
        // Prompt user for input
        Console.WriteLine("Enter an integer number of centuries:");
        int centuries = int.Parse(Console.ReadLine());

        // Define conversion constants
        int yearsPerCentury = 100;
        double daysPerYear = 365; // Average considering leap years
        int hoursPerDay = 24;
        int minutesPerHour = 60;
        int secondsPerMinute = 60;
        int millisecondsPerSecond = 1000;
        int microsecondsPerMillisecond = 1000;
        int nanosecondsPerMicrosecond = 1000;

        // Perform conversions
        int years = centuries * yearsPerCentury;
        double days = years * daysPerYear;
        double hours = days * hoursPerDay;
        double minutes = hours * minutesPerHour;
        double seconds = minutes * secondsPerMinute;
        double milliseconds = seconds * millisecondsPerSecond;
        double microseconds = milliseconds * microsecondsPerMillisecond;
        double nanoseconds = microseconds * nanosecondsPerMicrosecond;

        // Output results
        Console.WriteLine($"{centuries} centuries = {years} years = {Math.Floor(days)} days = {Math.Floor(hours)} hours = {Math.Floor(minutes)} minutes = {Math.Floor(seconds)} seconds = {Math.Floor(milliseconds)} milliseconds = {Math.Floor(microseconds)} microseconds = {Math.Floor(nanoseconds)} nanoseconds");
    
    }
    }

