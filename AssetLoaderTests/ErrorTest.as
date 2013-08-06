package {
	import com.ayanray.loaders.AssetLoader;
	
	import flash.display.Sprite;

	public class ErrorTest extends Sprite
	{
		public function ErrorTest()
		{
			new AssetLoader("haha.p21", {extra: {test: true}});
		}
	}
}
