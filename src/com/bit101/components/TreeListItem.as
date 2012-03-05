/**
 * ListItem.as
 * Keith Peters
 * version 0.9.10
 * 
 * A single item in a list. 
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package com.bit101.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class TreeListItem extends ListItem
	{
		protected var _twirl:Shape;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ListItem.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The string to display as a label or object with a label property.
		 */
		public function TreeListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object = null)
		{
			super(parent, xpos, ypos, data);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren() : void
		{
			super.addChildren();
			_twirl = new Shape();
			_twirl.x = 10;
			_twirl.y = 10;
			addChild(_twirl);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		public override function draw() : void
		{
			super.draw();
			
			if (_data) 
			{
				var indent:Number = 0;
				
				if (_data.hasOwnProperty("indent")) 
				{
					indent = _data.indent * 12;
				}
				
				_twirl.graphics.clear();
				if (_data.hasOwnProperty("items") && _data.items is Array) 
				{
					_label.x = 16 + indent;
					_twirl.graphics.beginFill(Style.LABEL_TEXT);
					_twirl.graphics.moveTo(-4, -5);
					_twirl.graphics.lineTo(4, 0);
					_twirl.graphics.lineTo(-4, 5);
					_twirl.graphics.lineTo(-4, -5);
					
					_twirl.x = 10 + indent;
					_twirl.rotation = (data.expanded) ? 90 : 0;
				}
				else 
				{
					_label.x = 15 + indent;
				}
			}
		}
		
	}
}