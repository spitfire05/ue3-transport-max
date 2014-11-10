using System;

namespace UE3Handler
{
    public class Actor
    {
        public string Name { get; set; }
        public string StaticMeshName { get; set; }
        public double3 Rotation { get; set; }
        public double3 Location { get; set; }
        public double3 Drawscale { get; set; }

        public Actor()
        {
            this.Rotation = new double3();
            this.Location = new double3();
            this.Drawscale = new double3(1, 1, 1);
        }

        public override string ToString()
        {
            return String.Format("{0}: P: {1}, R: {2}", base.ToString(), this.Location.ToString(), this.Rotation.ToString());
        }
    }
}
