///////////////////////////////////////////////////////////
//  NewUserMovieLayer.as
//  Macromedia ActionScript Implementation of the Class NewUserMovieLayer
//  Generated by Enterprise Architect
//  Created on:      26-十二月-2011 17:31:30
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.puremvc.view.ui.newUserLayer
{
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 26-十二月-2011 17:31:30
	 */
	public class NewUserMovieLayer extends Sprite
	{
		private var _newUserMovie:MovieClip;
		private var _enableClickRect:Rectangle = new Rectangle(0, 0, 756, 600);
		private var _frameClass:String = "Movie1";
		public function NewUserMovieLayer(obj:Object){
			
			if (obj) {
				_newUserMovie = obj as MovieClip;
				_newUserMovie.addEventListener("newUserMovieStop", newUserMovieHandler);
				_newUserMovie.addEventListener("changeFrameClass", changeFrameHandler);
				addChild(_newUserMovie);
				_newUserMovie.gotoAndStop(1);
				_newUserMovie[_frameClass].play();
				
			}
		}
		private var _label:String = "";
		private function newUserMovieHandler(event:Event):void {
			
			_label = _newUserMovie[_frameClass].currentLabel;
			_newUserMovie[_frameClass].stop();
			_newUserMovie.addEventListener(MouseEvent.CLICK, newUserMovieClick);
			
			switch(_label) {
				
				case "soldier1":
					_enableClickRect = new Rectangle(170, 500, 70, 80);
					break;
					
				case "soldier2":
					_enableClickRect = new Rectangle(245, 500, 70, 80);
					break;
					
				case "close":
					_enableClickRect = new Rectangle(330, 460, 90, 30);
					break;
					
				case "orePaper":
					_enableClickRect = new Rectangle(110, 255, 35, 30);
					_newUserMovie.removeEventListener(MouseEvent.CLICK, newUserMovieClick);
					addEventListener(Event.ENTER_FRAME, frameHandler);
					break;
					
				default:
					_enableClickRect = new Rectangle(0, 0, 756, 600);
					break;
			}
			
			
		}
		
		private function changeFrameHandler(event:Event):void {
			
			_frameClass = "Movie3";
			_newUserMovie.gotoAndStop(3);
		}
		
		private function newUserMovieClick(event:MouseEvent):void {
			
			if (_enableClickRect.containsPoint(new Point(mouseX,mouseY))) {
				
				if (_label == "close") {
					
					(UIMain.getInstance(UIMain.NAME) as UIMain).removeNewUserMovie();
				}
				else if(_label == "nextFrame"){
					_frameClass = "Movie2";
					_newUserMovie.gotoAndStop(2);
				}
				else {
					
					_newUserMovie[_frameClass].play();
					_newUserMovie.removeEventListener(MouseEvent.CLICK, newUserMovieClick);
				}
			}
		}
		/**
		 * 手纸滑过处理
		 * @param	event
		 */
		private function frameHandler(event:Event):void {
			
			if (_enableClickRect.containsPoint(new Point(mouseX, mouseY))) {
				
				_newUserMovie[_frameClass].play();
				removeEventListener(Event.ENTER_FRAME, frameHandler);
			}
		}
	}//end NewUserMovieLayer

}