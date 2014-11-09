using System;

namespace UE3Handler
{
    public class Actor
    {
        public string Name { get; set; }
        public double3 Rotation { get; set; }
        public double3 Location { get; set; }

        public Actor()
        {
            this.Rotation = new double3();
            this.Location = new double3();
        }

        public override string ToString()
        {
            return String.Format("{0}: P: {1}, R: {2}", base.ToString(), this.Location.ToString(), this.Rotation.ToString());
        }
    }

    public class double3 
    {
        public double x = 0;
        public double y = 0;
        public double z = 0;

        public override string ToString()
        {
            return String.Format("{0}/{1}/{2}", this.x, this.y, this.z);
        }
    }
}
