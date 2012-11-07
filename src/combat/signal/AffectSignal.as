package combat.signal
{
	import combat.data.AffectVO;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Karlis Zemdega
	 */
	public class AffectSignal extends Signal
	{
		public function AffectSignal()
		{
			super(AffectVO);
		}
		
	}

}