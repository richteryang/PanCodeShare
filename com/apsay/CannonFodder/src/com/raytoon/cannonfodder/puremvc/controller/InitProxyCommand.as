// /////////////////////////////////////////////////////////
// InitProxyCommand.as
// Macromedia ActionScript Implementation of the Class InitProxyCommand
// Generated by Enterprise Architect
// Created on:      02-六月-2011 10:54:02
// Original author: LuXianli
// /////////////////////////////////////////////////////////
package com.raytoon.cannonfodder.puremvc.controller
{
	import com.raytoon.cannonfodder.puremvc.model.JSONProxy;
	import com.raytoon.cannonfodder.puremvc.model.XMLProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 02-六月-2011 10:54:02
	 */
	public class InitProxyCommand extends SimpleCommand
	{
		public function InitProxyCommand()
		{
		}

		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new XMLProxy());
			facade.registerProxy(new JSONProxy());	
		}
	}
	// end InitProxyCommand
}