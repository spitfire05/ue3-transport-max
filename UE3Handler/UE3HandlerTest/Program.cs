using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UE3Handler;
using System.IO;

namespace UE3HandlerTest
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(String.Format("Version: {0}", ParserStub.getVersion()));

            var reader = new StreamReader("test.txt");

            var x = ParserStub.parse(reader.ReadToEnd());
            
            Console.WriteLine(x.Count);
            foreach (var xx in x)
            {
                Console.WriteLine(xx.ToString());
            }
            Console.ReadKey();
        }
    }
}
