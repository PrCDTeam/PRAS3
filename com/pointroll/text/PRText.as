﻿package com.pointroll.text{	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.Font;	import flash.text.TextFieldAutoSize;		import com.pointroll.utils.ClassProperty;	import com.pointroll.utils.PointRollUtils;	public class PRText {		public var _txtField:TextField;				public var _textFormat:TextFormat;		public function PRText(){}				public function createTextFormat(...args):void {			if (args.length) {				var _length:int = args.length;				_textFormat = new TextFormat();				for (var i:int = 0; i < _length; i++) {					if (_textFormat.hasOwnProperty(args[i].p) && ClassProperty.hasSetter(_textFormat,args[i].p))						_textFormat[args[i].p] = args[i].v;				}			}		}		//autoSize(txt:TextField, maxWidth:int, maxHeight:int):		public function createTextField(copy:String,isHtml:Boolean=false,...args):TextField {			var _length:int = args.length;			_txtField = new TextField();						if(_textFormat)				_txtField.defaultTextFormat = _textFormat;						if(isHtml){				_txtField.htmlText = copy;			}else{				_txtField.text = copy;			}						for (var i:int = 0; i < _length; i++) {				if (_txtField.hasOwnProperty(args[i].p) && ClassProperty.hasSetter(_txtField,args[i].p))					_txtField[args[i].p] = args[i].v;			}			return _txtField;		}		public function resizeText(txtField:TextField, maxWidth:int, maxHeight:int):void{			PointRollUtils.autoSize(txtField, maxWidth, maxHeight);		}	}}/*CLASS FONTPropertiesconstructorfontNamefontStylefontTypeMethodsenumerateFonts(enumerateDeviceFonts:Boolean = false):Array[static] Specifies whether to provide a list of the currently available embedded fonts.hasGlyphs(str:String):BooleanSpecifies whether a provided string can be displayed using the currently assigned font.registerFont(font:Class):void[static] Registers a font class in the global font list.CLASS TEXTFORMATPropertiesalign : StringIndicates the alignment of the paragraph.blockIndent : ObjectIndicates the block indentation in pixels.bold : ObjectSpecifies whether the text is boldface.  bullet : ObjectIndicates that the text is part of a bulleted list.color : ObjectIndicates the color of the text.Inheritedconstructor : ObjectA reference to the class object or constructor function for a given object instance.font : StringThe name of the font for text in this text format, as a string.indent : ObjectIndicates the indentation from the left margin to the first character in the paragraph.italic : ObjectIndicates whether text in this text format is italicized.kerning : ObjectA Boolean value that indicates whether kerning is enabled (true) or disabled (false).leading : ObjectAn integer representing the amount of vertical space (called leading) between lines.leftMargin : ObjectThe left margin of the paragraph, in pixels.letterSpacing : ObjectA number representing the amount of space that is uniformly distributed between all characters.rightMargin : ObjectThe right margin of the paragraph, in pixels.size : ObjectThe size in pixels of text in this text format.tabStops : ArraySpecifies custom tab stops as an array of non-negative integers.target : StringIndicates the target window where the hyperlink is displayed.underline : ObjectIndicates whether the text that uses this text format is underlined (true) or not (false).url : StringIndicates the target URL for the text in this text format.CENTER : String = "center"[static] Specifies that the text is to be treated as center-justified text.  LEFT : String = "left"[static] Specifies that the text is to be treated as left-justified text, meaning that the left side of the text field remains fixed and any resizing of a single line is on the right side.  NONE : String = "none"[static] Specifies that no resizing is to occur.  RIGHT : String = "right"[static] Specifies that the text is to be treated as right-justified text, meaning that the right side of the text field remains fixed and any resizing of a single line is on the left side.*/