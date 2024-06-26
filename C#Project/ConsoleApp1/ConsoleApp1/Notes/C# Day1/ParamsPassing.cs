namespace ConsoleApp1;

public class ParamsPassing
{
    public void PassingByValue(int a , int b, string str)
    {
        a = 80;
        b = 100;
        str = "world";
        Console.WriteLine($"Inside passing by value method: a ={a}, b={b}, str={str}");
    }
    
    public void PassingByReference(ref int a , ref int b, ref string str)
    {
        a = 80;
        b = 100;
        str = "world";
        Console.WriteLine($"Inside passing by reference method: a ={a}, b={b}, str={str}");
    }

    public void AreaofCircle(double radius, double pi=3.14 )
    {
        Console.WriteLine($"The area of the circle is {pi * radius * radius}");
    }

    public bool IsAuthentic(string uname, string password, out string msg)
    {
        if (uname == "Anjila" && password == "Antra123")
        {
            msg = "You have been authenticated";
            return true;
        }
        else
        {
            msg = "Invalid Credentials";
            return false;
        }
    }
    
    [Obsolete("Use AddNumbers(params int[]arr) instead", true)]
    public int AddTwoNumbers(int a, int b)
    {
        return a + b; 
    }
    
    [Obsolete("Use AddNumbers(params int[]arr) instead", true)]
    public int AddThreeNumbers(int a, int b, int c )
    {
        return a + b + c; 
    }
    
    public int AddNumbers(params int[] arr)
    {
        int sum = 0;
        for (int i = 0; i<arr.Length; i++)
        {
            sum = sum + arr[i];
        }
        return sum;
    }
    
}