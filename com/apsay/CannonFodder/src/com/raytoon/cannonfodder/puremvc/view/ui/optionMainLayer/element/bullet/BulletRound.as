///////////////////////////////////////////////////////////
//  BulletRound.as
//  Macromedia ActionScript Implementation of the Class BulletRound
//  Generated by Enterprise Architect
//  Created on:      12-七月-2011 12:14:34
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.bullet
{
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.Element;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.Towers;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.OptionMainLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.soundLayer.SoundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.tools.effects.BlitPlayer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 12-七月-2011 12:14:34
	 */
	public class BulletRound extends Element
	{
		//子弹射击单位
		private var _shooter:Element;
		//单位发出子弹速度
		private var _bSpeed:int = 15;
		public function set bSpeed(value:int):void {
			_bSpeed = value;
		}
		public function get bSpeed():int {
			return _bSpeed;
		}
		
		private var player:BlitPlayer;
		private var _bulletMovie:MovieClip;
		public function BulletRound(from:Element, pngName:String = "RoundFireBullet") {
			super();
			row = 20;
			_shooter = from;
			elementSkills = from.elementSkills;
			attack = from.attack;
			x = from.x;
			y = from.y;
			
			var _pngClass:Class = ApplicationDomain.currentDomain.getDefinition(pngName) as Class ;
			_bulletMovie = new _pngClass() as MovieClip;
			_bulletMovie.addFrameScript(_bulletMovie.totalFrames -1, removeThis);
			_bulletMovie.gotoAndStop(1);
			addChild(_bulletMovie);
			checkHurt();
		}
		
		/**
		 * 清空子弹
		 */
		override public function clear():void 
		{
			
		}
		private var roundFlag:int = 0;
		private var roundLine:int = 0;
		/**
		 * 重新渲染单位
		 */
		override public function rendering():void 
		{
			//roundLine += _bSpeed;
			//if (_shooter.minAttackRange <= roundLine && _shooter.maxAttackRange >= _bSpeed) {
				//状态关 检测碰撞（子弹是否击中）
				//checkHurt();
				//roundFlag = 1;
			//}
			
		}
		/**
		 * 散射攻击
		 * 碰撞检测，子弹是否击中单位
		 */
		private function checkHurt():void {
			
			_bulletMovie.play();
			
			var _hurtArray:Array = new Array();
			if (_shooter.adType == Element.ATTACK)
				_hurtArray =  (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).towerArr;
			else
				_hurtArray =  (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).attackArr;
			for each(var element:Element in _hurtArray) {
				if (element.moveType == 404 || _shooter == element || !element.isReady) continue;
				if (_shooter.elementSkills == 301 && element.elementType == Towers.ORGAN_TOWER) continue;
				if (Point.distance(_shooter.position, element.position) <= _shooter.maxAttackRange && Point.distance(_shooter.position, element.position) >= _shooter.minAttackRange && element.attackAble) {
					if (elementSkills == 213) {
						element.showFireHurtMovie();
						element.hurtHp((_shooter as Towers).skillsTime, (_shooter as Towers).skillsValue);
					}
					element.downHp(attack);
					element.showFireBulletHitMovie();
					(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(element.attackedSound);
					if (element.elementSkills == 202)
						element.bulletEffectName = "CommonBullet";
				}
			}
			attack = 0;
			_hurtArray = null;
			
		}
	
	}//end BulletRound

}