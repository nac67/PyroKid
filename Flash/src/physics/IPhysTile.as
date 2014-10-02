package physics {
    
    /**
     * ...
     * @author Cristian Zaloj
     */
    public interface IPhysTile {
        /**
         * Append Any Important Edges That Can Always Have Collisions
         * @param e Reference To Edge List
         */
        function ProvideEdgesSpecial(e:Array):void;
        /**
         * Append Edges Facing In The Specified Cardinal Direction
         * @param side Cardinal Facing Direction Of Edges
         * @param e Reference To Edge List
         */
        function ProvideEdgesDirection(side:int, e:Array):void;
        
        /**
         * True If This Provides A Grounding
         */
        function get IsGrounded():Boolean;
        
        /**
         * Used For Initial Binding Phase When A Level Loads
         * @param side Cardinal Direction
         * @return True If Binding In That Direction Is Possible
         */
        function CanBind(side:int):Boolean;
    }
    
}