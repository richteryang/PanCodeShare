package mvc.view {
	import org.puremvc.as3.interfaces.IMediator;

	import mvc.view.components.Comp;

	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * 主Mediator
	 * 注册子cmop的Mediator
	 * Mediator可以直接调用其对应comp和相关Proxy的公开方法
	 * 推荐用sendNotification执行相关Command，特别是数据Proxy操作
	 * 改变其他comp显示只能通过sendNotification给其Mediator
	 * 获得所需Proxy实例，同步数据通过Proxy实例直接取，异步数据，等Proxy发通知。
	 * 添加comp的交互事件(另一方式见comp注释)
	 * 添加通知监听列表，处理收到通知后的分发方法，只有Mediator才有listNotificationInterests和handleNotification
	 */
	public class AppMediator extends Mediator implements IMediator {
		// Cannonical name of the Mediator
		public static const NAME : String = "AppMediator";

		public function AppMediator(viewComponent : App) {
			super(NAME, viewComponent);
		}

		override public function onRegister() : void {
			// Create and register Mediators
			// components that were instantiated by the application
			var comp : Comp = new Comp();
			facade.registerMediator(new CompMediator(comp));
			app.comp = comp;
		}

		public function get app() : App {
			return viewComponent as app;
		}
	}
}