///////////////////////////////////////////////////////////
//  NumberFont.as
//  Macromedia ActionScript Implementation of the Class NumberFont
//  Generated by Enterprise Architect
//  Created on:      22-九月-2011 13:51:30
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.tools.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 22-九月-2011 13:51:30
	 */
	public class NumberFont extends Sprite
	{
		public static const FONT_PATH:String = "com.raytoon.CannonFodder.font.";//字体库路径
		public static const FONT_POINT:String = ".";
		public static const FONT_ONE:String = "fontOne.FontOne";//第一字体
		
		private var _fontNum:String;
		private var _fontName:String;
		private var _fontSpace:Number;
		private var _fontSize:Number;
		private var _fontLayer:Sprite;
		private var _fontBitmap:Bitmap;
		private var _fontBitmapData:BitmapData;
		private var _fontArr:Array;
		private var _fontClassArr:Array;
		/**
		 * 拼接字体数字
		 * @param	fontNum 显示数字字符串
		 * @param	fontName  显示字体名字
		 * @param	fontSpace  显示字体间距
		 * @param	fontSize    显示字体放大倍数
		 */
		public function NumberFont(fontNum:String = "0",fontName:String = FONT_ONE,fontSpace:Number = 1,fontSize:Number = 1,fontColor:uint = 0xFFFFFF){
			
			_fontNum = fontNum;
			_fontName = fontName;
			_fontSpace = fontSpace;
			_fontSize = fontSize;
			_fontArr = new Array();
			_fontClassArr = new Array();
			var _fontNumArr:Array = optionNumString(_fontNum);
			var _fontNumPath:String = FONT_PATH + _fontName;
			var _fontLen:int = _fontNumArr.length;
			_fontLayer = new Sprite();
			addChild(_fontLayer);
			for (var i:int = 0; i < _fontLen; i++ ) {
				
				var _fontNameClass:Class = ApplicationDomain.currentDomain.getDefinition(_fontNumPath.concat(_fontNumArr[i])) as Class;
				var _fontSp:Sprite = new _fontNameClass() as Sprite;
				_fontLayer.addChild(_fontSp);
				_fontClassArr.push(_fontNameClass);
				if (i > 0) {
					
					_fontSp.x = _fontArr[i - 1].x + _fontArr[i - 1].width + _fontSpace
				}
				_fontArr.push(_fontSp);
				_fontNameClass = null;
				_fontSp = null;
			}
			
			_fontLayer.scaleX = _fontSize;
			_fontLayer.scaleY = _fontSize;
			
			_fontBitmapData = new BitmapData(_fontLayer.width, _fontLayer.height, true, 0x000000);
			_fontBitmapData.draw(_fontLayer);
			_fontBitmap = new Bitmap(_fontBitmapData);
			addChild(_fontBitmap);
			removeChild(_fontLayer);
			_fontLayer = null;
			_fontArr = null;
			_fontClassArr = null;
		}
		
		private function optionNumString(tempString:String):Array {
			
			var tempStrArr:Array = [];
			var strLen:int = tempString.length;
			for (var i:int = 0; i < strLen; i ++ ) {
				
				var strInt:int = int(tempString.charAt(i));
				tempStrArr.push(strInt);
			}
			
			return tempStrArr;
		}
		/**
		 * 更新显示数字
		 * @param	num 更新后显示的数字
		 */
		public function updateNum(fontNum:String):void {
			
			_fontNum = fontNum;
			removeChild(_fontBitmap);
			_fontBitmap = null;
			_fontBitmapData = null;
			
			_fontArr = new Array();
			_fontClassArr = new Array();
			var _fontNumArr:Array = optionNumString(_fontNum);
			var _fontNumPath:String = FONT_PATH + _fontName;
			var _fontLen:int = _fontNumArr.length;
			_fontLayer = new Sprite();
			addChild(_fontLayer);
			for (var i:int = 0; i < _fontLen; i++ ) {
				
				var _fontNameClass:Class = ApplicationDomain.currentDomain.getDefinition(_fontNumPath.concat(_fontNumArr[i])) as Class;
				var _fontSp:Sprite = new _fontNameClass() as Sprite;
				_fontLayer.addChild(_fontSp);
				_fontClassArr.push(_fontNameClass);
				if (i > 0) {
					
					_fontSp.x = _fontArr[i - 1].x + _fontArr[i - 1].width + _fontSpace
				}
				_fontArr.push(_fontSp);
				_fontNameClass = null;
				_fontSp = null;
			}
			
			_fontLayer.scaleX = _fontSize;
			_fontLayer.scaleY = _fontSize;
			
			_fontBitmapData = new BitmapData(_fontLayer.width, _fontLayer.height, true, 0x000000);
			_fontBitmapData.draw(_fontLayer);
			_fontBitmap = new Bitmap(_fontBitmapData);
			addChild(_fontBitmap);
			removeChild(_fontLayer);
			_fontLayer = null;
			_fontArr = null;
			_fontClassArr = null;
		}

	}//end NumberFont

}