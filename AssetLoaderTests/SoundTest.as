package {
	import com.ayanray.loaders.AssetLoader;
	
	import flash.display.Sprite;
	import flash.media.Sound;

	public class SoundTest extends Sprite
	{
		public function SoundTest()
		{
			//var obj:Object = {"assets/audio/sample1.mp3": {onOpen: soundOpen, onID3: soundID3, onUnload: soundUnload, onUpdate: soundUpdate, onComplete: soundLoadComplete, extra: {name: "Operation Hallucination"}}};
			var obj:Object = {"assets/audio/sample2.wav": {onOpen: soundOpen, onID3: soundID3, onUnload: soundUnload, onUpdate: soundUpdate, onComplete: soundLoadComplete, extra: {name: "Chimes"}}};
			new AssetLoader( obj );
		}
		
		private function soundLoadComplete( obj:Object ):void
		{
			trace("Sound load complete");
			var asset:Sound = obj.asset as Sound;
			asset.play();
		}
		
		private function soundOpen( obj:Object ):void
		{
			trace("Sound loading begun...");
		}
		
		private function soundID3( obj:Object ):void
		{
			trace("Sound ID3 Received: Artist ", obj.event.currentTarget.id3.artist);
		}
		
		private function soundUnload( obj:Object ):void
		{
			trace("Sound Unloaded");
		}
		
		private function soundUpdate( obj:Object ):void
		{
			trace("Progress Event on song:", obj.extra.name, obj.e.bytesLoaded/obj.e.bytesTotal );
		}
	}
}
