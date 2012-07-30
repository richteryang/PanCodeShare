///////////////////////////////////////////////////////////
//  EventBindingData.as
//  Macromedia ActionScript Implementation of the Class EventBindingData
//  Generated by Enterprise Architect
//  Created on:      02-六月-2011 16:28:06
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.tools
{
	import flash.events.Event;
	/**
	 * 扩展Event类，可携带数据
	 * @author LuXianli
	 * @version 1.0
	 * @created 02-六月-2011 16:28:06
	 */
	public class EventBindingData extends Event
	{
		public var data:Object;

		public function EventBindingData(type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false) : void {
			
			super(type,bubbles,cancelable);
			this.data = data;
		}

	}//end EventBindingData

}