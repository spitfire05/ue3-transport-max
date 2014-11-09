using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using System.Reflection;
using System.Globalization;
using System.Threading;

namespace UE3Handler
{
    public class ParserStub
    {
        private static double ratio = 0.0054931640625; // conversion ratio

        public static string getVersion()
        {
            int major = Assembly.GetExecutingAssembly().GetName().Version.Major;
            int minor = Assembly.GetExecutingAssembly().GetName().Version.Minor;
            int patch = Assembly.GetExecutingAssembly().GetName().Version.Build;
            return String.Format("{0}.{1}.{2}", major, minor, patch);
        }
        
        public static List<Actor> parseFromClipboard()
        {
            return parse(Clipboard.GetText());
        }

        public static List<Actor> parse(string data)
        {
            var nameRegex = new Regex("Name=\"(.*)\"");
            var rotationRegex = new Regex(@"Rotation=\(Pitch=(-?\d+),Yaw=(-?\d+),Roll=(-?\d+)\)");
            var positionRegex = new Regex(@"Location=\(X=(-?\d+.?\d*),Y=(-?\d+.?\d*),Z=(-?\d+.?\d*)\)");

            var actors = new List<Actor>();

            // Mkae sure we read the numbers correctly
            Thread.CurrentThread.CurrentCulture = new CultureInfo("en-US");

            using (StringReader reader = new StringReader(data))
            {
                string line;
                int n = 0; // current line number
                int obj = 0; // current object deepness
                Actor curActor = null;
                while ((line = reader.ReadLine()) != null)
                {
                    // Read line-by-line
                    ++n;
                    line = line.Trim();

                    // Check for opening map tag
                    if (n == 1 && line != "Begin Map")
                    {
                        throw new InvalidDataException("Missing opening tag");
                    }

                    // new Actor
                    if (line.StartsWith("Begin Actor"))
                    {
                        curActor = new Actor();
                        continue;
                    }

                    // end Actor
                    if (line == "End Actor")
                    {
                        if (curActor != null && curActor.Name != null)
                        {
                            actors.Add(curActor);
                            curActor = null;
                            continue;
                        }
                        throw new InvalidDataException(String.Format("Actor with missing data on line {0}", n));
                    }

                    // begin object
                    if (line.StartsWith("Begin Object"))
                    {
                        ++obj;
                    }

                    // end object
                    if (line.StartsWith("End Object"))
                    {
                        --obj;
                    }

                    // Check here if we are in actor definition, and not in any children objects
                    if (curActor == null || obj > 0)
                    {
                        continue;
                    }

                    // Name
                    if (nameRegex.IsMatch(line))
                    {
                        var matches = nameRegex.Matches(line);
                        curActor.Name = matches[0].Groups[1].Value;
                        continue;
                    }

                    // Rotation
                    if (rotationRegex.IsMatch(line))
                    {
                        // Read byte values
                        var matches = rotationRegex.Matches(line);
                        int x, y, z;
                        int.TryParse(matches[0].Groups[1].Value, out x);
                        int.TryParse(matches[0].Groups[2].Value, out y);
                        int.TryParse(matches[0].Groups[3].Value, out z);

                        // Convert to euler degrees
                        double xd, yd, zd;
                        xd = x * ratio;
                        yd = y * ratio;
                        zd = z * ratio;
                        curActor.Rotation.x = Math.Round(xd, 2);
                        curActor.Rotation.y = Math.Round(yd, 2);
                        curActor.Rotation.z = Math.Round(zd, 2);
                        continue;
                    }

                    // Position
                    if (positionRegex.IsMatch(line))
                    {
                        var matches = positionRegex.Matches(line);
                        double x, y, z;
                        double.TryParse(matches[0].Groups[1].Value, out x);
                        double.TryParse(matches[0].Groups[2].Value, out y);
                        double.TryParse(matches[0].Groups[3].Value, out z);

                        curActor.Location.x = x;
                        curActor.Location.y = y;
                        curActor.Location.z = z;
                        continue;
                    }
                }
            }
            return actors;
        }
    }
}
