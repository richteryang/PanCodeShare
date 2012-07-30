///////////////////////////////////////////////////////////
//  BulletLineOne.as
//  Macromedia ActionScript Implementation of the Class BulletLineOne
//  Generated by Enterprise Architect
//  Created on:      19-十月-2011 17:04:20
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.bullet
{
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.Element;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.Soldier;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.Towers;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.OptionMainLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.soundLayer.SoundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.tools.effects.BlitPlayer;
	import com.raytoon.cannonfodder.tools.utils.GlobalVariable;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 19-十月-2011 17:04:20
	 */
	public class BulletLineTwo extends Element
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
		//子弹 X 轴 分速度
		private var _xSpeed:Number;
		//子弹 Y 轴 分速度
		private var _ySpeed:Number;
		private var player:BlitPlayer;
		private var _bulletMovie:MovieClip;
		private var _bulletHitMovie:MovieClip;
		private var _bulletHitClass:Class;
		private var _path:int = 1;
		private var _obElement:Element;
		private var _lineLen:Number;
		public function BulletLineTwo(from:Element, path:int = 2, pngName:String = "LineBullet") {
			super();
			row = from.row;
			num = from.num;
			_shooter = from;
			attack = from.attack;
			x = from.x;
			y = from.y;
			
			var _pngClass:Class = ApplicationDomain.currentDomain.getDefinition(pngName) as Class ;
			_bulletMovie = new _pngClass() as MovieClip;
			addChild(_bulletMovie);
			_bulletHitClass = ApplicationDomain.currentDomain.getDefinition("LineOB") as Class;
			_bulletHitMovie = new _bulletHitClass() as MovieClip;
			
			var _towerArr:Array = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).towerArr;
			var _obTowerArr:Array = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).obstacleTowerArr;
			var _attackArr:Array = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).attackArr;
			
			for each (var element2:Element in _towerArr) {
				if (element2.elementType == Towers.ORGAN_TOWER) continue;
				if (element2.row == row && element2.num > num) {
					
					if (_obElement) {
						if (_obElement.num > element2.num)
							_obElement = element2;
					}else {
						_obElement = element2;
					}
				}
			}
			
			for each (var element222:Element in _obTowerArr) {
				if (element222.elementType == Towers.ORGAN_TOWER) continue;
				if (element222.row == row && element222.num > num) {
					
					if (_obElement) {
						if (_obElement.num > element222.num)
							_obElement = element222;
					}else {
						_obElement = element222;
					}
				}
			}
			
			for each (var element22:Element in _attackArr) {
				if (element22.elementSkills != 308) continue;
				if (element22.row == row && element22.num > num) {
					
					if (_obElement) {
						if (_obElement.num >= element22.num)
							_obElement = element22;
					}else {
						_obElement = element22;
					}
				}
			}
			
			if (_obElement) {
				_lineLen = Point.distance(position, _obElement.position);
				_bulletMovie.width = _lineLen;
			}else {
				_bulletMovie.width = GlobalVariable.STAGE_WIDTH - position.x;
			}
			_bulletMovie.addChild(_bulletHitMovie);
			_bulletHitMovie.x = 92;
			
			_towerArr = null;
			_obTowerArr = null;
			_attackArr = null;
		}
		/**
		 * 清空子弹
		 */
		override public function clear():void 
		{
			super.clear();
			
		}
		
		private var _bAngle:Number;
		/**
		 * 重新渲染单位
		 */
		override public function rendering():void 
		{
			if (_bulletMovie) {
				if (_bulletMovie.alpha == 1)
					checkHurt();
				_bulletMovie.scaleY -= 0.02;
				_bulletMovie.alpha -= 0.02;
				if (_bulletMovie.alpha <= 0.04) {
					removeThis();
				}
			}
			if (_obElement) {
				if (_obElement.elementSkills == 308) {
					
					_lineLen = Point.distance(position, _obElement.position);
					_bulletMovie.width = _lineLen;
					_bulletHitMovie.x = _bulletMovie.width;
				}
			}
		}
		
		/**
		 * 碰撞检测，子弹是否击中单位
		 */
		private function checkHurt():void {
			if (_obElement) {
				
				if (_obElement.elementSkills == 308) {
					_shooter.downHp(attack * (_obElement as Soldier).skillsPercent);
				}
			}
			
			var hurtArray:Array = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).attackArr;
			
			for each(var element:Element in hurtArray) {
				
				if (_obElement) {
					if (element.isReady && element.attackAble && element.row == row && element.num <= _obElement.num && element.num >= num) {
						if (element.elementSkills == 308) {
							_obElement = element;
							_shooter.downHp(attack * (element as Soldier).skillsPercent);
						}else {
							
							element.showAttackLineMovie(attack);
							(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(element.attackedSound);
						}
					}
				}else {
					if (element.isReady && element.attackAble && element.row == row && element.num >= num) {
						
						if (element.elementSkills == 308) {
							_obElement = element;
							_shooter.downHp(attack * (element as Soldier).skillsPercent);
						}else {
							
							element.showAttackLineMovie(attack);
							(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(element.attackedSound);
						}
					}
				}
			}
			attack = 0;
			hurtArray = null;
		}
	}//end BulletLineTwo

}