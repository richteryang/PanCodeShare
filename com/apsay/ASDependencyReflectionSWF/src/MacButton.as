package {
	/**
	 * @author Panhezeng
	 */
	public class MacButton implements IButton {
		private var description : String;

		public function MacButton() {
			description = "Mac风格按钮";
			trace(description);
		}

		public function showInfo() : String {
			return description;
		}
	}
}
