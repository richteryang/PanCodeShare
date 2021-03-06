// // // // // // // // // // ///////////////////////////////////////
// ElementTopContainer.as
// Macromedia ActionScript Implementation of the Class ElementTopContainer
// Generated by Enterprise Architect
// Created on:      28-十一月-2011 10:57:15
// Original author: LuXianli
// // // // // // // // // // ///////////////////////////////////////
package com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.element {
	import com.raytoon.cannonfodder.tools.utils.UIXML;
	import com.raytoon.cannonfodder.tools.utils.UIClass;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;

	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 28-十一月-2011 10:57:15
	 */
	public class ElementTopContainer extends Sprite {
		public function ElementTopContainer() {
		}

		private var _containerArr : Array = [];
		private var _iconArr : Array = [];

		/**
		 * 排行榜数据显示  
		 * @param	dataArr  单元素 数组
		 */
		public function showTopContainer(dataArr : Array) : void {
			var _my : int = 0;

			for (var i : int = 0; i < dataArr.length; i++ ) {
				var _objArr : Array = dataArr[i] as Array;
				var _mClass : Class = ApplicationDomain.currentDomain.getDefinition(UIClass.TOP_CONTAINER) as Class;
				var _mc : Sprite = new _mClass() as Sprite;
				addChild(_mc);
				_mc.y = _my;
				
				(_mc as Object).dataRival = [_objArr[0], _objArr[3], _objArr[1]];
				(_mc as Object).dataMapID = _objArr[4];
				(_mc["langLevel"] as TextField).text = String(_objArr[1]);
				(_mc["langName"] as TextField).text = String(_objArr[3]);
				(_mc["langMapTitle"] as TextField).text = String(UIXML.uiXML.phrase.map);
				(_mc["langMapLevelTitle"] as TextField).text = String(UIXML.uiXML.phrase.level);
				(_mc["langMapLevel"] as TextField).text = String(UIXML.mapXML.maps.(@id == _objArr[4]).mapLevel);
				(_mc["langMapNameTitle"] as TextField).text = String(UIXML.uiXML.phrase.name);
				(_mc["langMapName"] as TextField).text = String(UIXML.mapXML.maps.(@id == _objArr[4]).mapName);
				(_mc["langWinTitle"] as TextField).text = String(UIXML.uiXML.phrase.win);
				(_mc["langWin"] as TextField).text = String(_objArr[5]);
				var _picUrl : String = String(_objArr[2]);
				var _picLoader : Loader = new Loader();
				(_mc["icon"] as DisplayObjectContainer).addChild(_picLoader);
				_picLoader.x = _picLoader.y = 1;
				_picLoader.load(new URLRequest(_picUrl));
				_picLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, picLoadIoError);
				_my += _mc.height + 3;
				_containerArr.push(_mc);
				_iconArr.push(_picLoader);
				_mc = null;
				_mClass = null;
				_picLoader = null;
				_picUrl = null;
				_objArr = null;
			}
		}

		private function picLoadIoError(event : IOErrorEvent) : void {
		}

		/**
		 * 清理显示排行榜数据
		 */
		public function clear() : void {
			for each (var load:Loader in _iconArr) {
				load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, picLoadIoError);
				try {
					(load.content as Bitmap).bitmapData.dispose();
				} catch (e : *) {
				}
				try {
					load.unloadAndStop();
				} catch(e : *) {
				}
			}
			_iconArr = [];
			for each (var mc:Sprite in _containerArr) {
				removeChild(mc);
				mc = null;
			}
			_containerArr = [];
		}
	}
	// end ElementTopContainer
}