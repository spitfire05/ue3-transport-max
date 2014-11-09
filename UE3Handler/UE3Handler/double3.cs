using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UE3Handler
{
    /// <summary>
    /// A 3-dimensional vector class.
    /// </summary>
    public class double3
    {
        public double x { get; set; }
        public double y { get; set; }
        public double z { get; set; }

        public double3()
        {
            this.x = 0;
            this.y = 0;
            this.z = 0;
        }

        public double3 (double x_val, double y_val, double z_val)
        {
            this.x = x_val;
            this.y = y_val;
            this.z = z_val;
        }

        public double this[int index]
        {
            get
            {
                switch(index)
                {
                    case 0: { return x; }
                    case 1: { return y; }
                    case 2: { return z; }
                    default: throw new ArgumentOutOfRangeException();
                }
            }
            set
            {
                switch(index)
                {
                    case 0: { x = value; break; }
                    case 1: { y = value; break; }
                    case 2: { z = value; break; }
                    default: throw new ArgumentOutOfRangeException();
                }
            }
        }

        public static double3 operator +(double3 v1, double3 v2)
        {
            return new double3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
        }

        public static double3 operator -(double3 v1, double3 v2)
        {
            return new double3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
        }

        public static double3 operator -(double3 v)
        {
            return new double3(-v.x, -v.y, -v.z);
        }

        public static double3 operator *(double3 v, double d)
        {
            return new double3(v.x * d, v.y * d, v.z * d);
        }

        public static double3 operator /(double3 v, double d)
        {
            return new double3(v.x / d, v.y / d, v.z / d);
        }
    }
}
