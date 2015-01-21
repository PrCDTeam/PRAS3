package {

	public class XMLUtils {
		
 		public static function  removeNS(data:XML):XML {
			var myXML;
			try {
				var modified:String = data.toString().replace("xmlns=", "xmlns:default=");
				var pattern:RegExp = new RegExp(":(?!/)", "gi");
				var transmuted:String = modified.replace(pattern, "_");
				myXML = new XML(transmuted);
			} catch (e:Error) {
				myXML = data;
			}
			return myXML;
		}

	}
}