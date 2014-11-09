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
}
