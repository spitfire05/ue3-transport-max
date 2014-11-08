using System;

namespace UE3Handler
{
    public class Actor
    {
        public string Name { get; set; }
        public ActorRotation Rotation { get; set; }
        public ActorPosition Position { get; set; }

        public Actor()
        {
            this.Rotation = new ActorRotation();
            this.Position = new ActorPosition();
        }

        public override string ToString()
        {
            return String.Format("{0}: P: {1}, R: {2}", base.ToString(), this.Position.ToString(), this.Rotation.ToString());
        }
    }

    public class ActorRotation 
    {
        public double x = 0;
        public double y = 0;
        public double z = 0;

        public override string ToString()
        {
            return String.Format("{0}/{1}/{2}", this.x, this.y, this.z);
        }
    }

    public class ActorPosition
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
