package physics {
    
    /**
     * ...
     * @author Cristian Zaloj
     */
    public interface IPhysEdgeProvider {
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
    }
    
}