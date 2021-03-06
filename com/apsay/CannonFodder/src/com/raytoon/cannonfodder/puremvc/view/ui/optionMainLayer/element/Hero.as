///////////////////////////////////////////////////////////
//  Hero.as
//  Macromedia ActionScript Implementation of the Class Hero
//  Generated by Enterprise Architect
//  Created on:      17-六月-2011 10:25:43
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element
{
	import com.raytoon.cannonfodder.puremvc.view.mediator.optionMainLayerMediator.OptionMainLayerMediator;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.OptionMainLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.bullet.Bullet;
	import com.raytoon.cannonfodder.puremvc.view.ui.soundLayer.SoundLayer;
	import com.raytoon.cannonfodder.tools.EventBindingData;
	import com.raytoon.cannonfodder.tools.aStar.Node;
	import com.raytoon.cannonfodder.tools.load.DynamicLoadOriginal;
	import com.raytoon.cannonfodder.tools.utils.GlobalVariable;
	import com.raytoon.cannonfodder.tools.utils.MapRectInfo;
	import com.raytoon.cannonfodder.tools.utils.UIClass;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.xml.XMLSource;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 17-六月-2011 10:25:43
	 */
	public class Hero extends Element
	{
		//走一格时间 毫秒数
		private var walkTime:int = 1400;
		//英雄的速度
		private var _xSpeed:Number = 0;
		private var _ySpeed:Number = 0;
		private var _xMirrorSpeed:Number = 0;
		private var _yMirrorSpeed:Number = 0;
		private var _speed:Number = 1.5;
		public function set speed(value:int):void {
			_speed = value * GlobalVariable.RECT_WIDTH / 150;
			walkTime = Number(GlobalVariable.RECT_WIDTH / _speed) * 1000 / 30;
			if (_mirrorSpeedFlag) {
				_mirrorSpeed = _speed;
				_mirrorSpeedFlag = false;
			}
		}
		public function get speed():int {
			return _speed;
		}
		// 改变移动速度
		override public function elementSpeed(value:Number):void 
		{
			_speed = (1 + value) * _mirrorSpeed;
		}
		//英雄移动类型
		private var _runType:int = 401;
		public function set runType(value:int):void {
			_runType = value;
			moveType = value;
			
			switch (value) {
				
				case 402:
					runFunction = intermittentRun;
				break;
				
				case 403:
					runFunction = jumpRun;
				break;
				
				case 404:
					runFunction = floatingRun;
				break;
				
				case 405:
					runFunction = boringRun;
				break;
			}
			
		}
		
		public function get runType():int {
			return _runType;
		}
		
		//移动速度备份存储
		private var _mirrorSpeed:Number = 1.5;
		private var _mirrorSpeedFlag:Boolean = true;
		public function set mirrorSpeed(value:Number):void {
			_mirrorSpeed = value;
		}
		public function get mirrorSpeed():Number {
			return _mirrorSpeed;
		}
		public function Hero(heroName:String,heroHP:int,heroArmor:int){
			
			super(true,true)
			adType = Element.ATTACK;
			attackElementType = Element.HERO;
			elementDownLayer = new Sprite();
			addChild(elementDownLayer);
			elementLayer = new Sprite();
			addChild(elementLayer);
			elementUpLayer = new Sprite();
			addChild(elementUpLayer);
			elementLayer.y = 10;
			elementLayer.mouseEnabled = false;
			viewUnit = new DynamicLoadOriginal(heroName,true,"",heroHP,heroArmor,heroHP,heroArmor); 
			elementLayer.addChild(viewUnit);
			//viewUnit.y = 10;
			viewFlag = 1;
		}
		
		//光环 加成属性 ==========================================================
		private var _gemProperty:int = 0;
		private var _haloPath:String = "com.raytoon.paohui.gem.";
		private var _haloName:String;
		private var _gemIconName:String = "";
		private var _gemLangName:String = "";
		private var _gemNote:String = "";
		public function additionGemProperty(gemProperty:int, haloName:String,gemPercent:Number,gemIconName:String = "",gemLangName:String = "",gemNote:String = ""):void {
			
			_gemProperty = gemProperty;
			_haloName = haloName;
			_gemIconName = gemIconName;
			_gemLangName = gemLangName;
			_gemNote = gemNote;
			if (elementDownLayer) {
				
				var _gemClass:Class = ApplicationDomain.currentDomain.getDefinition(_haloPath + haloName) as Class;
				elementDownLayer.addChild(new _gemClass() as DisplayObject);
				_gemClass = null;
//				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addGemIcon(haloName + "Icon");
			}
			
			if (elementUpLayer) {
				
				var _mClass:Class = ApplicationDomain.currentDomain.getDefinition(gemIconName) as Class;
				var obj:Sprite = new _mClass() as Sprite;
				elementUpLayer.addChild(obj);
				obj.addEventListener(MouseEvent.ROLL_OVER, gemIconRollOver);
				obj.addEventListener(MouseEvent.ROLL_OUT, gemIconRollOut);
				obj.x = -obj.width / 2;
				if (viewUnit) {
					
					if (viewUnit.height > GlobalVariable.RECT_HEIGHT) {
						obj.y = -viewUnit.height - obj.height;
					}
					else {
						obj.y = -70 - obj.height - 5;
					}
				}
			}
			
			switch(_gemProperty) {
				
				case 1://加成回血速度
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).inductor.additionElementBackHpTime(gemPercent);
				break;
				
				case 4://加成攻击力
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).inductor.additionElementAttack(gemPercent);
				break;
				
				case 5://加成 移动速度
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).inductor.additionElementSpeed(gemPercent);
				break;
				
				case 7://加成系统补给速度
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).additionSupply(gemPercent);
				break;
				
				case 8://加成英雄获得荣誉值
					additionHonor(gemPercent);
				break;
			}
		}
		
		private function gemIconRollOver(event:MouseEvent):void {
			
			UICreate.createTooltips(_gemLangName, _gemNote, event.currentTarget as DisplayObject);
		}
		
		private function gemIconRollOut(event:MouseEvent):void {
			
			var stageTop : DisplayObject = stage.getChildAt(this.stage.numChildren - 1);
			if (getQualifiedClassName(stageTop).indexOf(UIClass.TIP_PREFIX) != -1) UICommand.destroy(stageTop);
			UIMain.mouseCursor = UIMain.NEW_COMMON;
		}
		
		override public function elementDeath():void 
		{
			super.elementDeath();
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(deathSound);
			switch(_gemProperty) {
				
				case 1://加成回血速度
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).inductor.cancelAdditionBackHpTime();
				break;
				
				case 4://加成攻击力
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).inductor.cancelAdditionAttack();
				break;
				
				case 5://加成 移动速度
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).inductor.cancelAdditionSpeed();
				break;
				
				case 7://加成系统补给速度
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).additionSupply(0);
				break;
				
				
			}
			
			clear();
			(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).deathPeopleSum( { "dataType":Element.HERO, "dataID":id, "dataSum":1 },paper );
		}
		
		override public function clear():void 
		{
			super.clear();
			killSkills();
		}
		/**
		 * 重写单位暂停工作方法
		 * @param	value
		 */
		override public function elementWork(value:Boolean):void 
		{
			super.elementWork(value);
			
			if (_hurtSpeedTimer)
				value ? _hurtSpeedTimer.start() : _hurtSpeedTimer.stop();
			
			if (runTimer)
				value ? runTimer.start() : runTimer.stop();
			
			
		}
		
		private function killSkills():void {
			
			killHurtSpeed();
			killRun();
			
		}
		
		/**
		 * 英雄消失
		 */
		private function disappear():void {
			
			x += 1;
			_showNumber -= 0.01;
			
			
			if (_showNumber <= 0) {
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).removeElement(this);
			}
		}
		private var _shape:Shape;
		private var _showNumber:Number = 1;
		/**
		 * 添加遮罩层
		 */
		private function showMask():void {
			(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).removeHeroSkillsButton(_skillsName);
			(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).removeGemIcon();
		}
		/**
		 * 发射子弹
		 */
		override public function shoot():void {
			if (!(attackAble && isReady))
				return;
			if (target.isReady && target.lifeHP > 0) {
				
				(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(shootSound);
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addElement(new Bullet(this, target, bulletEffectName,attack,_skills));
			}
			else {
				
				target = null;
			}
		}
		
		//显示技能按钮
		public function showSkillsButton():void {
			
			//(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addSkillsButton(skillsName, showHeroSkillsRange, _cdTime, 0, skillsButtonName);
			(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).heroSkillsFunction = showHeroSkillsRange;
		}
		
		//行走标志位
		private var _runFlag:int = 1;
		public function set runFlag(value:int):void {
			_runFlag = value;
		}
		public function get runFlag():int {
			return _runFlag;
		}
		private var lastShoot:Number = -1;
		public var runFunction:Function = ordinaryRun;
		private var _startRunFlag:int = 0;
		private var walkArray:Array = [];
		private var walkLength:int = 0;
		private var statusRunFlag:Boolean = true;
		private var statusStopFlag:Boolean = true;
		/**
		 * 重新渲染
		 */
		override public function rendering():void 
		{
			//if (isHurting)
				//elementFlashing();
			//if (_runFlag == 1 && _startRunFlag == 0) {
				//_startRunFlag = 1;
				//runFunction();
				//walkArray = runArray;
				//walkLength = runArray.length;
			//}
			//
			//if (_runFlag == 1 && running)
				//runFunction();
			//else if (running)
				//disappear();
			
			//if (target == null)
				//return;
			
			//if ((UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).getTargetIndex(target) == -1 || Point.distance(this.position,target.position) > this.maxAttackRange) {
				//
				//target = null;
				//return;
			//}
			
			if (_heroSkillsFlag) {
				
				if (_heroSkillsLayer) {
					
					_heroSkillsLayer.x = _heroSkillsRange ? stage.mouseX - _heroSkillsRange.width / 2 : stage.mouseX;
					_heroSkillsLayer.y = _heroSkillsRange ? stage.mouseY - _heroSkillsRange.height / 2 : stage.mouseY;
				}
			}
			
		}
		//英雄行走方式==============================================================================================================================
		
		private function killRun():void {
			
			if (runTimer) {
				runTimer.removeEventListener(TimerEvent.TIMER, runTimerRun);
				runTimer.stop();
				runTimer = null;
			}
		}
		private var _nowX:int = 0;
		private var _nowY:int = 0;
		private var _nextX:int = 0;
		private var _nextY:int = 0;
		private var walkFlag:int = 0;
		private var _walkDistance:Number = 0;
		
		public static const HERO_WALK_COMPLETE:String = "heroWalkComplete";//英雄到达终点
		/**
		 * 401
		 * 普通行走
		 */
		public function ordinaryRun():void {
			
			if (walkFlag == 0)
				walk();
			
			x += _xSpeed;
			y += _ySpeed;
			
			if (Point.distance(position, new Point(_nowX,_nowY)) >= _walkDistance) {
				
				if (walkFlag < runArray.length - 1) {
					//attackAble = true;
					walk();
				
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).removeLayerElement(this);
					row = Math.floor((y - OptionMainLayer.layerHeight) / GlobalVariable.RECT_HEIGHT);
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addElement(this);
					num = Math.floor((x - OptionMainLayer.layerWidth) / GlobalVariable.RECT_WIDTH);
					if (MapRectInfo.attackRectangle.containsPoint(position)) {
						if (walkFlag == 2) {
							
							(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addSkillsButton(skillsName, skillsFunction, _cdTime, 0, skillsButtonName);
							SoundLayer.getInstance().playSound(goInSound);
						}
					}
				}
				else {
					
					showMask();
					_runFlag = 0;
					
				}
			}
			
		}
		/**
		 * 行走阶段路径计算
		 */
		private function walk():void {
			
			if (runArray.length > 0) {
				
				_nowX = (runArray[walkFlag] as Node).unitX;
				_nowY = (runArray[walkFlag] as Node).unitY;
				x = _nowX;
				y = _nowY;
				if (walkFlag < walkLength - 1) {
					_nextX = (runArray[walkFlag + 1] as Node).unitX;
					_nextY = (runArray[walkFlag + 1] as Node).unitY;
				}else {
					
					return;
				}
				if (_nextX - _nowX > 0) {
					if (viewFlag == 1)
						viewUnit.scaleX = 1;
						_scalxNum = 1;
				}else if (_nextX - _nowX < 0){
					if (viewFlag == 1)
						viewUnit.scaleX = -1;
						_scalxNum = -1;
				}
				//计算需行走直线距离
				_walkDistance = Point.distance(new Point(_nowX,_nowY),new Point(_nextX,_nextY));
				//计算行走角度
				var _bAngle:Number = Math.atan2(_nextY - _nowY, _nextX - _nowX);
				//设定行走 X ，Y 分速度
				_xSpeed = _speed * Math.cos(_bAngle);
				_ySpeed = _speed * Math.sin(_bAngle);
				_xMirrorSpeed = _mirrorSpeed * Math.cos(_bAngle);
				_yMirrorSpeed = _mirrorSpeed * Math.sin(_bAngle);
				//if (walkFlag > 0)
					//isReady = true;
				walkFlag ++;
			}
		}
		private var runTimer:Timer;
		private var _stopFlag:int = 0;
		/**
		 * 402
		 * 间断行走
		 */
		public function intermittentRun():void {
			
			if (_stopFlag < 2) {
				
				if (walkFlag == 0)
					walk();
				if (statusRunFlag) {
					
					statusRunFlag = false;
					statusStopFlag = true;
					//isReady = true;
					//attackAble = true;
					if (viewFlag == 1)
						viewUnit.showFrame(1);
				}
				x += _xSpeed;
				y += _ySpeed;
				
				if (Point.distance(position, new Point(_nowX,_nowY)) >= _walkDistance) {
					
					if (walkFlag < runArray.length - 1) {
						
						_stopFlag ++;
						walk();
						
						(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).removeLayerElement(this);
						row = Math.floor((y - OptionMainLayer.layerHeight) / GlobalVariable.RECT_HEIGHT);
						(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addElement(this);
						num = Math.floor((x - OptionMainLayer.layerWidth) / GlobalVariable.RECT_WIDTH);
						
					}else {
						
						showMask();
						_runFlag = 0;
						
					}
				}
			}else {
				
				if (statusStopFlag) {
					
					runTimer = new Timer(walkTime, 1);
					runTimer.addEventListener(TimerEvent.TIMER, runTimerRun);
					runTimer.start();
					statusStopFlag = false;
					statusRunFlag = true;
					if (viewFlag == 1)
						viewUnit.showFrame(3);
					//isReady = false;
					//attackAble = false;
				}
				
			}
			
		}
		
		private function runTimerRun(event:TimerEvent):void {
			
			_stopFlag = 0;
			runTimer.removeEventListener(TimerEvent.TIMER, runTimerRun);
			runTimer.stop();
			runTimer = null;
		}
		/**
		 * 403
		 * 跳跃行走
		 */
		public function jumpRun():void {
			
			if (walkFlag == 0)
				jumpWalk();
				
			x += _xSpeed;
			y += _ySpeed;
			
			if (Point.distance(position, new Point(_nowX,_nowY)) >= _walkDistance) {
				
				if (walkFlag < runArray.length - 1) {
					//attackAble = true;
					jumpWalk();
					
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).removeLayerElement(this);
					row = Math.floor((y - OptionMainLayer.layerHeight) / GlobalVariable.RECT_HEIGHT);
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addElement(this);
					num = Math.floor((x - OptionMainLayer.layerWidth) / GlobalVariable.RECT_WIDTH);
					
				}else {
					
					showMask();
					_runFlag = 0;
					
				}
			}
		}
		/**
		 * 跳跃行走路径计算
		 */
		private function jumpWalk():void {
			
			if (runArray.length > 0) {
				
				_nowX = (runArray[walkFlag] as Node).unitX;
				_nowY = (runArray[walkFlag] as Node).unitY;
				x = _nowX;
				y = _nowY;
				if (walkFlag < runArray.length - 1) {
					_nextX = (runArray[walkFlag + 1] as Node).unitX;
					_nextY = (runArray[walkFlag + 1] as Node).unitY;
				}else {
					showMask();
					_runFlag = 0;
					
					return;
				}
				
				//计算需行走直线距离
				_walkDistance = Point.distance(new Point(_nowX,_nowY),new Point(_nextX,_nextY));
				//计算行走角度
				var _bAngle:Number = Math.atan2(_nextY - _nowY, _nextX - _nowX);
				//设定行走 X ，Y 分速度
				_xSpeed = _speed * Math.cos(_bAngle);
				_ySpeed = _speed * Math.sin(_bAngle);
				_xMirrorSpeed = _mirrorSpeed * Math.cos(_bAngle);
				_yMirrorSpeed = _mirrorSpeed * Math.sin(_bAngle);
				//if (walkFlag > 0)
					//isReady = true;
				walkFlag += 3;
			}
		}
		/**
		 * 404
		 * 浮游行走
		 */
		public function floatingRun():void {
			
			if (walkFlag == 0)
				floatingWalk();
			
			x += _xSpeed;
			y += _ySpeed;
			num = Math.floor((x - OptionMainLayer.layerWidth) / GlobalVariable.RECT_WIDTH);
			//if (!isReady) {
				//if (MapRectInfo.attackRectangle.containsPoint(position))
					//isReady = true;
			//}
			
			if (Point.distance(position, new Point(_nowX, _nowY)) >= _walkDistance) {
				showMask();
				_runFlag = 0;
				dispatchEvent(new EventBindingData(HERO_WALK_COMPLETE,this));
			}
			
		}
		
		private function floatingWalk():void {
			
			if (runArray.length > 0) {
				
				_nowX = (runArray[walkFlag] as Node).unitX;
				_nowY = (runArray[walkFlag] as Node).unitY;
				x = _nowX;
				y = _nowY;
				_nextX = (runArray[runArray.length - 1] as Node).unitX;
				_nextY = (runArray[runArray.length - 1] as Node).unitY;
				
				//计算需行走直线距离
				_walkDistance = Point.distance(new Point(_nowX,_nowY),new Point(_nextX,_nextY));
				//计算行走角度
				var _bAngle:Number = Math.atan2(_nextY - _nowY, _nextX - _nowX);
				//设定行走 X ，Y 分速度
				_xSpeed = _speed * Math.cos(_bAngle);
				_ySpeed = _speed * Math.sin(_bAngle);
				_xMirrorSpeed = _mirrorSpeed * Math.cos(_bAngle);
				_yMirrorSpeed = _mirrorSpeed * Math.sin(_bAngle);
				walkFlag ++;
			}
		}
		/**
		 * 405
		 * 钻地行走
		 */
		public function boringRun():void {
			
			if (_stopFlag < 2) {
				
				if (walkFlag == 0)
					walk();
				if (statusRunFlag) {
					
					statusRunFlag = false;
					statusStopFlag = true;
					//isReady = false;
					//attackAble = false;
					if (viewFlag == 1)
						viewUnit.showFrame(1);
				}
				x += _xSpeed;
				y += _ySpeed;
				
				if (Point.distance(position, new Point(_nowX,_nowY)) >= _walkDistance) {
					
					if (walkFlag < runArray.length - 1) {
						
						_stopFlag ++;
						walk();
						
						(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).removeLayerElement(this);
						row = Math.floor((y - OptionMainLayer.layerHeight) / GlobalVariable.RECT_HEIGHT);
						(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addElement(this);
						num = Math.floor((x - OptionMainLayer.layerWidth) / GlobalVariable.RECT_WIDTH);
					}else {
						
						showMask();
						_runFlag = 0;
						
					}
				}
			}else {
				
				if (statusStopFlag) {
					
					runTimer = new Timer(walkTime, 1);
					runTimer.addEventListener(TimerEvent.TIMER, runTimerRun);
					runTimer.start();
					statusStopFlag = false;
					statusRunFlag = true;
					if (viewFlag == 1)
						viewUnit.showFrame(3);
					//isReady = true;
					//attackAble = true;
				}
				
			}
			
		}
		//==================钻地行走备份==================
		//public function boringRun():void {
			//
			//if (walkFlag == 0)
				//walk();
			//
			//x += _xSpeed;
			//y += _ySpeed;
			//
			//if (Point.distance(position, new Point(_nowX, _nowY)) >= _walkDistance) {
				//
				//if (walkFlag < runArray.length - 1) {
					//
					//walk();
					//if (walkFlag % 3 == 2) {
						//
						//if (viewUnit.getFrame() != 2) {
							//isReady = false;
							//viewUnit.showFrame(1);
						//}
						//attackAble = false;
						//
					//}else {
						//
						//isReady = true;
						//viewUnit.showFrame(3);
						//attackAble = true;
						//
					//}
				//}else {
					//
					//showMask();
					//_runFlag = 0;
					//dispatchEvent(new EventBindingData(HERO_WALK_COMPLETE,this));
				//}
			//}
		//}
		//英雄技能=================================================================================
		
		private var _skills:int = 0;
		private var _skillsValue:Number = 0;
		private var _cdTime:Number = 0;
		private var _skillsButtonName:String;
		private var _skillsCoolTime:int = 0;
		private var _skillsRange:Number = 0;
		private var _skillSoundName:String;
		public function set skills(value:int):void {
			_skills = value;
			elementSkills = value;
			
			var skillsXmlList:XMLList = XMLSource.getXMLSource("HeroSkillsInfo.xml").heroSkills.(@id == value);
			_cdTime = Number(skillsXmlList.cdTime);
			_skillsCoolTime = int(skillsXmlList.skillsCoolTime);
			var _property:Array = String(skillsXmlList.skillsProperty).split(",");
			var _percent:Array = String(skillsXmlList.skillsPercent).split(",");
			_skillsRange = Number(skillsXmlList.skillsRange);
			_skillsButtonName = String(skillsXmlList.skillsButton);
			_skillSoundName = String(skillsXmlList.skillSound);
			skillsXmlList = null;
			if (_skillsRange == 0) {
				
				_skillsRange = 10 * GlobalVariable.RECT_WIDTH;
			}
			else {
				
				_skillsRange *= GlobalVariable.RECT_WIDTH;
			}
			
			for (var i:int = 0; i < _property.length; i ++ ) {
				
				if (int(_property[i]) == 1) {
					_skillsValue += Math.floor(lifeHP * Number(_percent[i]));
				}
				else if (int(_property[i]) == 2) {
					_skillsValue += Math.floor(attack * Number(_percent[i]));
				}
				else if (int(_property[i]) == 3) {
					_skillsValue += Math.floor(armor * Number(_percent[i]));
				}
				else if (int(_property[i]) == 4) {
					_skillsValue += Math.floor(defense * Number(_percent[i]));
				}
			}
			
			
			switch(value) {
				
				case 101:
					skillsFunction = treatmentSkills;
					break;
					
				case 102:
					skillsFunction = asylumSkills;
					break;
					
				case 103:
					skillsFunction = giftSkills;
					break;
					
				case 104:
					_skillsValue += _skillsCoolTime;
					skillsFunction = fogSkills;
					break
					
				case 105:
					skillsFunction = treatmentAllSkills;
					break;
					
				case 106:
					skillsFunction = shockSkills;
					break;
					
				case 107:
					skillsFunction = burstSkills;
					break;
					
				case 108:
					skillsFunction = bombSkills;
					break;
			}
			
		}
		public function get skills():int {
			return _skills;
		}
		public function get cdTime():Number {
			return _cdTime;
		}
		public function get skillsButtonName():String {
			return _skillsButtonName;
		}
		private var _skillsName:String;
		public function set skillsName(value:String):void {
			_skillsName = value;
		}
		public function get skillsName():String {
			return _skillsName;
		}
		//技能作用对象数组
		private var _skillsObjArray:Array = [];
		private var _point:Point;
		/**
		 * 101
		 *治疗
		 */
		private function treatmentSkills(point:Point):void {
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			_skillsObjArray = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).attackArr;
			
			var _skillsObj:Element;
			
			for each(var element:Element in _skillsObjArray) {
				
				if (!element.isReady || Point.distance(point,element.position) > _skillsRange) continue;
				if (_skillsObj != null) {
					
					if (_skillsObj.percentHp > element.percentHp)
						_skillsObj = element;
					
				}else {
					
					_skillsObj = element;
				}
				
			}
			
			if (_skillsObj != null)
				_skillsObj.plusHp(_skillsValue);
			_skillsObj = null;
			
			_skillsObjArray = [];
		}
		/**
		 *  102
		 *庇护
		 */
		private function asylumSkills(point:Point):void {
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			
			_skillsObjArray = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).attackArr;
			
			for each(var element:Element in _skillsObjArray) {
				
				if (!element.isReady || element.armor > 0 || Point.distance(point,element.position) > _skillsRange) continue;
				element.mirrorArmor = _skillsValue;
				element.plusArmor(_skillsValue);
			}
			
			_skillsObjArray = [];
			
		}
		
		/**
		 * 103
		 * 恩赐
		 */
		private function giftSkills(point:Point):void {
			
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			var _paperSum:int = 0;
			var _soldierArr:Array = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).soldierArr;
			
			for each(var soldier:Soldier in _soldierArr) {
				
				if (soldier.isReady) {
					soldier.showPaperMovie();
					_paperSum += 1;
				}
			}
			_soldierArr = null;
			if (_paperSum == 0) return;
			(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).addOrePaper(new OrePaper(_paperSum*_skillsValue, _skillsCoolTime, 2,false), position.x, position.y + GlobalVariable.RECT_HEIGHT/2);
		}
		
		/**
		 * 104
		 * 干扰
		 */
		private function fogSkills(point:Point):void {
			
			
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			_skillsObjArray = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).towerArr;
			
			//for each (var len:Element in _skillsObjArray) {
				//if (len == this) continue;
				//len.elementDistance = Point.distance(point, len.position);
			//}
			//
			for each(var element:Element in _skillsObjArray) {
				if (!element.isReady || element.elementType != Towers.ENERGY_TOWER || Point.distance(point,element.position) > _skillsRange) continue;
				element.showFogMovie();
				(element as Towers).stopWork(_skillsValue);
			}
			
			_skillsObjArray = [];
		}
		
		/**
		 * 105
		 * 群疗
		 */
		private function treatmentAllSkills(point:Point):void {
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			_skillsObjArray = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).attackArr;
			
			for each(var element:Element in _skillsObjArray) {
				
				if (!element.isReady || Point.distance(point,element.position) > _skillsRange) continue;
				element.plusHp(_skillsValue);
			}
			
		}
		
		/**
		 * 106
		 * 反震  
		 */
		private function shockSkills(point:Point):void {
			
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			_skillsObjArray = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).towerArr;
			
			for each (var len:Element in _skillsObjArray) {
				if (len == this) continue;
				len.elementDistance = Point.distance(point, len.position);
			}
			var _skillsObj:Element;
			for each(var element:Element in _skillsObjArray) {
				if (!element.isReady || element.elementType != Towers.DEFENCE_TOWER || Point.distance(point,element.position) > _skillsRange) continue;
				if (_skillsObj) {
					if (_skillsObj.elementDistance > element.elementDistance)
						_skillsObj = element;
				}else {
					_skillsObj = element;
				}
			}
			if (_skillsObj != null) {
				_skillsObj.elementSleep(true);
				(_skillsObj as Towers).stopWork(_skillsValue);
				_skillsObj = null;
			}
			
			_skillsObjArray = [];
		}
		
		/**
		 * 107
		 * 复仇
		 */
		private function burstSkills(point:Point):void {
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			showSkillsHurtMovie("HeroSkillsBurstMovie");
			var _towerArr:Array = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).towerArr;
			for each(var element:Element in _towerArr) {
				
				if (!element.isReady || Point.distance(point, element.position) > _skillsRange || element.elementType == Towers.ORGAN_TOWER) continue;
				element.downHp(_skillsValue);
			}
			
			_towerArr = null;
		}
		/**
		 * 108
		 * 炸弹
		 */
		private function bombSkills(point:Point):void {
			
			//if (MapRectInfo.attackRectangle.containsPoint(position))
				showSkillsMovie();
			//else
				//return;
			_point = point;
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(_skillSoundName);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(skillSound);
			showSkillsHurtMovie("HeroSkillsBombMovie");
			
			var _towerArr:Array = (UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).towerArr;
			
			for each (var tower:Towers in _towerArr) {
				
				if (!tower.isReady || Point.distance(point, tower.position) > _skillsRange || tower.elementType == Towers.DAMAGE_TOWER || tower.elementType == Towers.OBSTACLE_TOWER || tower.elementType == Towers.ORGAN_TOWER) continue;
				tower.plusDefence(-_skillsValue);
			}
			_towerArr = null;
		}
		
		private var _skillsMovie:MovieClip;
		private var _skillsMovieFlag:Boolean = true;
		private function showSkillsMovie():void {
			
			if (_skillsMovieFlag) {
				_skillsMovieFlag = false;
				var _mClass:Class = ApplicationDomain.currentDomain.getDefinition("HeroSkillsMovie") as Class;
				_skillsMovie = new _mClass() as MovieClip;
				_skillsMovie.addFrameScript(_skillsMovie.totalFrames - 1, function():void { _skillsMovie.stop(); } );
				elementUpLayer.addChild(_skillsMovie);
				_skillsMovie.y = -GlobalVariable.RECT_HEIGHT / 2;
				_mClass = null;
			}else {
				if (_skillsMovie)
					_skillsMovie.play();
			}
		}
		
		private var _skillsHurtMovie:MovieClip;
		/**
		 * 显示竟能释放动画
		 * @param	valueName
		 */
		private function showSkillsHurtMovie(valueName:String):void {
			
			if (!_skillsHurtMovie) {
				
				var _mClass:Class = ApplicationDomain.currentDomain.getDefinition(valueName) as Class;
				_skillsHurtMovie = new _mClass() as MovieClip;
				_skillsHurtMovie.addFrameScript(_skillsHurtMovie.totalFrames - 1, function():void { _skillsHurtMovie.stop(); _skillsHurtMovie.visible = false; } );
				elementDownLayer.addChild(_skillsHurtMovie);
				_skillsHurtMovie.x = _point != null ? _point.x - position.x : 0;
				_skillsHurtMovie.y = _point != null ? _point.y - position.y : 0;
				_mClass = null;
			}else {
				if (_skillsHurtMovie) {
					_skillsHurtMovie.visible = true;
					_skillsHurtMovie.x = _point != null ? _point.x - position.x : 0;
					_skillsHurtMovie.y = _point != null ? _point.y - position.y : 0;
					_skillsHurtMovie.play();
				}
			}
		}
		//英雄技能光圈===============================================================================
		
		private var _heroSkillsLayer:Sprite;
		private var _heroSkillsRange:MovieClip;
		private var _heroSkillsRangeMask:Sprite;
		private var _heroSkillsFlag:Boolean = false;
		private var _heroCardObj:Object;
		private function showHeroSkillsRange(value:Object):void {
			
			if (value.playback) {
				skillsFunction(new Point(value.playback.x,value.playback.y));
				return;
			}
			_heroCardObj = value;
			if (_heroCardObj != null && _skillsRange >= 10 * GlobalVariable.RECT_WIDTH) {
				skillsFunction(new Point(GlobalVariable.STAGE_WIDTH / 2, GlobalVariable.STAGE_HEIGHT / 2));
				UICommand.changeHeroSkillCard(_heroCardObj);
				return;
			}
			var _frame:int = 1;
			switch(_skills) {
				
				case 101:
					_frame = 1;
					break;
				
				case 102:
					_frame = 4;
					break;
					
				case 103:
					skillsFunction(new Point(GlobalVariable.STAGE_WIDTH / 2, GlobalVariable.STAGE_HEIGHT / 2));
					return;
					break;
					
				case 104:
					_frame = 3;
					break;
					
				case 105:
					skillsFunction(new Point(GlobalVariable.STAGE_WIDTH / 2, GlobalVariable.STAGE_HEIGHT / 2));
					return;
					break;
					
				case 106:
					_frame = 6;
					break;
					
				case 107:
					_frame = 7;
					break;
					
				case 108:
					_frame = 8;
					break;
			}
			
			_heroSkillsLayer = new Sprite();
			var _mClass:Class = UICommand.getClass("HeroSkillsRangeMC");
			_heroSkillsRange = new _mClass() as MovieClip;
			(UIMain.getInstance(UIMain.NAME) as UIMain).addChild(_heroSkillsLayer);
			_heroSkillsLayer.addChild(_heroSkillsRange);
			_heroSkillsRange.gotoAndStop(_frame);
			
			var _rw:int = _heroSkillsRange.width;
			var _rh:int = _heroSkillsRange.height;
			
			_heroSkillsRange.width = int(_rw * _skillsRange  / _rh) * 2;
			_heroSkillsRange.height = int(_rh * _skillsRange  / _rw) * 2;
			
			_heroSkillsRangeMask = new Sprite();
			_heroSkillsRangeMask.graphics.beginFill(0xFFFFFF,0.01);
			_heroSkillsRangeMask.graphics.drawRect(0,0, _heroSkillsRange.width, _heroSkillsRange.height);
			_heroSkillsRangeMask.graphics.endFill();
			_heroSkillsLayer.addChild(_heroSkillsRangeMask);
			_heroSkillsRangeMask.addEventListener(MouseEvent.CLICK, heroSkillsRangeMaskClickHandler);
			
			_heroSkillsFlag = true;
		}
		
		private function heroSkillsRangeMaskClickHandler(event:MouseEvent):void {
			
			
			_heroSkillsFlag = false;
			
			_heroSkillsRangeMask.removeEventListener(MouseEvent.CLICK, heroSkillsRangeMaskClickHandler);
			_heroSkillsLayer.removeChild(_heroSkillsRangeMask);
			_heroSkillsRangeMask = null;
			_heroSkillsLayer.removeChild(_heroSkillsRange);
			_heroSkillsRange = null;
			(UIMain.getInstance(UIMain.NAME) as UIMain).removeChild(_heroSkillsLayer);
			_heroSkillsLayer = null;
			
			if (MapRectInfo.attackRectangle.containsPoint(new Point(stage.mouseX, stage.mouseY))) {
				
				if (_heroCardObj != null) UICommand.changeHeroSkillCard(_heroCardObj);
				if (!MapRectInfo.attackRectangle.containsPoint(new Point(stage.mouseX, stage.mouseY))) return;
				skillsFunction(new Point(stage.mouseX, stage.mouseY));
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).saveHeroSkills(new Point(stage.mouseX, stage.mouseY));
			}
		}
		
		//冰塔攻击时调用=============================================================================
		
		private var _hurtSpeedTimer:Timer;
		private var _hurtSpeedFlag:Boolean = true;
		
		override public function hurtSpeed(_hurtSpeed:Number = 0.2, _hurtSpeedTime:int = 3):void {
			
			if (_hurtSpeedFlag) {
				if (viewFlag == 1)
					viewUnit.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 20, 230, 0);
				_hurtSpeedFlag = false;
				_speed *= (1 - _hurtSpeed);
				_xSpeed *= (1 - _hurtSpeed);
				_ySpeed *= (1 - _hurtSpeed);
				_hurtSpeedTimer = new Timer(_hurtSpeedTime * 1000, 1);
				_hurtSpeedTimer.addEventListener(TimerEvent.TIMER, hurtSpeedTimerHandler);
				_hurtSpeedTimer.start();
			}else {
				if (_hurtSpeedTimer) {
					
					_hurtSpeedTimer.reset();
					_hurtSpeedTimer.start();
				}
			}
		}
		
		private function hurtSpeedTimerHandler(event:TimerEvent):void {
			
			if (!_hurtSpeedFlag) {
				if (viewFlag == 1)
					viewUnit.transform.colorTransform = new ColorTransform();
				_speed = _mirrorSpeed;
				_xSpeed = _xMirrorSpeed;
				_ySpeed = _yMirrorSpeed;
				_hurtSpeedTimer.removeEventListener(TimerEvent.TIMER, hurtSpeedTimerHandler);
				_hurtSpeedTimer.reset();
				_hurtSpeedTimer = null;
				_hurtSpeedFlag = true;
			}
		}
		
		private function killHurtSpeed():void {
			
			if (_hurtSpeedTimer) {
				
				_hurtSpeedTimer.removeEventListener(TimerEvent.TIMER, hurtSpeedTimerHandler);
				_hurtSpeedTimer.reset();
				_hurtSpeedTimer = null;
			}
		}
		
		//装备 加成 属性 ==================================================================================
		
		public function equipAdditionProperty(eType:String, eId:int):void {
			
			var _equipXmlList:XMLList = XMLSource.getXMLSource("Equipment.xml").equipCategory.(@type == eType).equip.(@id == eId);
			
			switch (eType) {
				
				case "red":
					plusProperty(int(_equipXmlList.addProperty), int(_equipXmlList.addSum));
				break;
				
				case "solid":
					var _solidArr:Array = String(_equipXmlList.addSum).split(",");
					
					for (var i:int = 0; i < 4; i ++ ) {
						plusProperty(i + 1, _solidArr[i] as int);
					}
				break;
				
				case "color":
					var _colorOneArr:Array = String(_equipXmlList.addProperty).split(",");
					var _colorTwoArr:Array = String(_equipXmlList.addSum).split(",");
					for (var j:int = 0; j < 2; j++ ) {
						plusProperty(_colorOneArr[j] as int, _colorTwoArr[j] as int);
					}
				break;
				
			}
			
			_equipXmlList = null;
		}
		
		private function plusProperty(pId:int,value:int):void {
			
			switch (pId) {
				
				case 1:
					equipAdditionHp(value);
				break;
				
				case 2:
					equipAdditionAttack(value);
				break;
				
				case 3:
					equipAdditionArmor(value);
				break;
				
				case 4:
					equipAdditionDefence(value);
				break;
			}
		}
	}//end Hero

}