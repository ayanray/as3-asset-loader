package com.ayanray.loaders.flexunit4.tests 
{
	import com.ayanray.loaders.AssetLoader;
	/**
	 *  This test case checks basic AssetLoader properties... 
	 * I.e. are you using AssetLoader correctly (1, 2 args)?
	 * 
	 * @author Ayan
	 * 
	 */	
	public class BasicAssetLoaderTest 
	{
		[Test] 
		public function testAssetLoaderSingleImage():void 
		{   
			try
			{
				new AssetLoader("assets/images/image1.jpg", {});
			}
			catch(e:Error)
			{
				throw new Error("Image not found.");
			}
		}
		
		[Test] 
		public function testAssetLoaderUnknownFiletype():void 
		{   
			tryFiletype("assets/images/image.jpg", true);
			tryFiletype("assets/images/image2.jpeg", true);
			tryFiletype("assets/images/image.png", true);
			tryFiletype("assets/images/image.gif", true);
			tryFiletype("assets/images/image.p2o", false);
			//tryFiletype(".mp3", true);
		}
		
		private function tryFiletype(extension:String, expecting:Boolean):void
		{
			var result:Boolean = true;
			try
			{
				new AssetLoader("" + extension, {});
			}
			catch(e:Error)
			{
				result = false;
			}
			
			if(result != expecting) throw new Error("Trying filetype: " + extension + " did not result in expected result: " + expecting);
		}
		////////////////////////////////////////
		// Wrong Argument Error Tests (limited)
		////////////////////////////////////////
		
		[Test(expects="flash.errors.Error")] 
		public function testAssetLoaderWrongArguments0():void 
		{   
			// Test 1 Argument (non-object)
			try 
			{
				new AssetLoader(); 
			}
			catch(e:Error)
			{
				return;
			}
			throw new Error("Exception not thrown on 0 arguments.");
		}
		
		[Test(expects="flash.errors.Error")] 
		public function testAssetLoaderWrongArguments1():void 
		{   
			// Test 1 Argument (non-object)
			try 
			{
				new AssetLoader("/assets/images/image1.jpg"); 
			}
			catch(e:Error)
			{
				return;
			}
			throw new Error("Exception not thrown on 1 string argument.");
		}
		
		[Test(expects="flash.errors.Error")] 
		public function testAssetLoaderWrongArguments2():void 
		{ 
			// Test 2 Arguments (string, string)
			try 
			{
				new AssetLoader("/assets/images/image1.jpg", "/assets/images/image2.jpg"); 
			}
			catch(e:Error)
			{
				return;
			}
			throw new Error("Exception not thrown on 2 string arguments.");
		}
		
		[Test(expects="flash.errors.Error")] 
		public function testAssetLoaderWrongArguments3():void 
		{ 
			// Test 2 Arguments (string, string)
			try 
			{
				new AssetLoader("/assets/images/image1.jpg", "/assets/images/image2.jpg", "/assets/images/image3.jpg"); 
			}
			catch(e:Error)
			{
				return;
			}
			throw new Error("Exception not thrown on 3 string arguments.");
		}
	}
}