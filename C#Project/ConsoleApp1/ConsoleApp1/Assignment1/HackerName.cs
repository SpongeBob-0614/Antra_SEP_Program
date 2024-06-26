namespace ConsoleApp1.Assignment1;

public class HackerName
{
    public static void Main()
    {
        // Asking user for their favorite color
        Console.WriteLine("Enter your favorite color:");
        string favoriteColor = Console.ReadLine();

        // Asking user for their astrology sign
        Console.WriteLine("Enter your astrology sign:");
        string astrologySign = Console.ReadLine();

        // Asking user for their street address number
        Console.WriteLine("Enter your street address number:");
        string streetAddressNumber = Console.ReadLine();

        // Generating the hacker name
        string hackerName = favoriteColor + astrologySign + streetAddressNumber;

        // Displaying the hacker name
        Console.WriteLine("Your hacker name is " + hackerName);
    }
    
}

