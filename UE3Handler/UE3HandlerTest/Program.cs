using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UE3Handler;

namespace UE3HandlerTest
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(String.Format("Version: {0}", ParserStub.getVersion()));

            var x = ParserStub.parse("Begin Map\nBegin Actor\nRotation=(Pitch=01,Yaw=-77312,Roll=2)\nName=\"ROStaticMeshDestructible_318\"\nEnd Actor\nEnd Map\n");
            
            Console.WriteLine(x.Count);
            foreach (var xx in x)
            {
                Console.WriteLine(xx.ToString());
            }
            Console.ReadKey();
        }
    }
}
