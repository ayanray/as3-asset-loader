package {
	import com.ayanray.loaders.AssetLoader;
	
	import flash.display.Sprite;
	import flash.net.NetStream;

	public class VideoTest extends Sprite
	{
		private var netStream:NetStream;
		
		public function VideoTest()
		{
			var obj:Object = {"assets/video/teleport.flv": {onComplete: loadComplete, onMetaData: metaDataHandler, extra: {name: "Teleport"}}};			
			new AssetLoader( obj );
		}
		
		private function onError(obj:Object):void
		{
			trace(obj.extra.name, "has thrown an error");
		}
		
		private function loadComplete(obj:Object):void
		{
			trace("Load complete");
			netStream = obj.netStream as NetStream;
			this.addChild(obj.asset);
		}
		
		private function metaDataHandler(obj:Object):void
		{
			this.getChildAt(0).width = obj.metaData.width;
			this.getChildAt(0).height = obj.metaData.height;
			
			trace("Meta Data // Width:", obj.metaData.width, "Height:", obj.metaData.height);
		}
		
		private function cuePointHandler(obj:Object):void
		{
			 trace("CuePoint:", obj.cuePoint.name, "\t" + obj.cuePoint.time);
		}
	}
}
