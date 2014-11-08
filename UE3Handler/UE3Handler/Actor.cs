
namespace UE3Handler
{
    public class Actor
    {
        public string Name { get; set; }
        public ActorRotation Rotation { get; set; }

        public Actor()
        {
            this.Rotation = new ActorRotation();
        }
    }

    public class ActorRotation 
    {
        public double x = 0;
        public double y = 0;
        public double z = 0;
    }
}
