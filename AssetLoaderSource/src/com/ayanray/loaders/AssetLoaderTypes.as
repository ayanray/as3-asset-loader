﻿/**	Copyright (c) 2007-2008 Ayan Ray | http://www.ayanray.com**	Permission is hereby granted, free of charge, to any person obtaining a copy*	of this software and associated documentation files (the "Software"), to deal*	in the Software without restriction, including without limitation the rights*	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell*	copies of the Software, and to permit persons to whom the Software is*	furnished to do so, subject to the following conditions:**	The above copyright notice and this permission notice shall be included in*	all copies or substantial portions of the Software.**	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR*	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,*	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE*	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER*	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,*	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN*	THE SOFTWARE.**/package com.ayanray.loaders {	public class AssetLoaderTypes	{		// Images		public static const JPG		:String = "IMG";		public static const JPEG	:String = "IMG";		public static const PNG		:String = "IMG";		public static const GIF		:String = "IMG";				// SWFs		public static const SWF		:String = "IMG";				// Sound		public static const MP3		:String = "SOUND";		public static const F4A		:String = "SOUND";		public static const F4B		:String = "SOUND";		//public static const WAV		:String = "SOUND"; // can only be supported by run-time byteArray -> SWF				// Video		public static const FLV		:String = "VIDEO";		public static const F4V		:String = "VIDEO";		public static const F4P		:String = "VIDEO";		//public static const MP4		:String = "VIDEO";		//public static const M4V		:String = "VIDEO";		//public static const 3GPP	:String = "VIDEO";		//public static const MOV	:String = "VIDEO"; // possible with bytearray		//public static const AVI	:String = "VIDEO"; // possible with bytearray		//public static const DV	:String = "VIDEO"; // possible with bytearray		//public static const MPG	:String = "VIDEO"; // possible with bytearray		//public static const MPEG	:String = "VIDEO"; // possible with bytearray				// XML		public static const XML		:String = "XML";		public static const HTML	:String = "XML";				// CSS		public static const TEXT	:String = "TEXT";	}}