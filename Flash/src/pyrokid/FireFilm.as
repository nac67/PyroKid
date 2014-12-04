package pyrokid 
{
    import pyrokid.graphics.Filmstrip;
	/**
     * ...
     * @author Nick Cheng
     */
    public class FireFilm extends Filmstrip
    {
        
        public function FireFilm() 
        {
            super(new Embedded.FireTileStripBMP(), 15, 25, 80, 80, 5, 19);
        }
        
    }

}