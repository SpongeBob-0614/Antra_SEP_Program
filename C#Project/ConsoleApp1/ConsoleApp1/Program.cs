/*
// See https://aka.ms/new-console-template for more information

using System.Text;
using ConsoleApp1;

int a = 10;
Console.WriteLine("The value of a is" + a);

double b = 2.3424223;
Console.WriteLine($"The value of b is {b}");

float c = 4.2342342f;
Console.WriteLine(c);

decimal d = 3.432422m;
Console.WriteLine(d);

string s = "hello world!";
Console.WriteLine(s);

int? e = null;

if (e.HasValue)
{
    Console.WriteLine("e does have value");
}
else
{
    Console.WriteLine("e does not have any value");
}

string S = "hello world";

StringBuilder str = new StringBuilder("hello world");
str[0] = 'H';
Console.WriteLine(str);


int Sunday = 1;
int Monday = 2;
int Tuesday = 3;
int Wednesday = 4;
int Thurday = 5;
int Friday = 6;
int Saturday = 7;

int dayofWeek = 17;

if (dayofWeek == Monday)
{
    Console.WriteLine("It's Monday");
}

DaysOfWeek today = DaysOfWeek.Monday;
Console.WriteLine((int)today);
*/

using ConsoleApp1;

ParamsPassing demo = new ParamsPassing();
int x = 30;
int y = 10;
string str = "hello";
Console.WriteLine($"Before calling passing by value method: x = {x} y={y},str={str}");
demo.PassingByValue(x, y, str);
Console.WriteLine($"After calling passing by value method: x = {x} y={y}, str={str}");
Console.WriteLine("-------------------------------------------------------");
Console.WriteLine($"Before calling passing by refernce method: x = {x} y={y}, str={str}");
demo.PassingByReference(ref x, ref y, ref str);
Console.WriteLine($"After calling passing by reference method: x = {x} y={y}, str={str}");
Console.WriteLine("-------------------------------------------------------");
demo.AreaofCircle(4);
demo.AreaofCircle(4, 3);

int a = 10;
object o = a;  //boxing
int j = (int) o; //unboxing
//type casting

string s = "hello";
Console.WriteLine(demo.IsAuthentic("Anjila", "Antra123", out s));
Console.WriteLine(s);

Console.WriteLine(demo.AddNumbers(20,20));
Console.WriteLine(demo.AddNumbers(20,20,100));
Console.WriteLine(demo.AddNumbers(20,20,100,14, 55));

//Console.WriteLine(demo.AddTwoNumbers(1,2));