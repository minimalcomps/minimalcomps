/**
 * TabPanel.as
 * Jos Yule
 * version 0.1
 * 
 * Essentially a bunch of Push Buttons with a bunch of Panels below. 
 * 
 * Copyright (c) 2011 Jos Yule
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
	import flash.events.Event;
	
	public class TabPanel extends Component
	{
		protected var _tabs:Array;
		protected var _hbox:HBox;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function TabPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		
		/**
		 * Initializes the component.
		 */
		protected override function init():void
		{
			super.init();
			setSize(200, 150);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren() : void
		{
			const TABS:int = 2;
			var tab:PushButton;
			var panel:Panel;
			
			_hbox = new HBox(this);
			_hbox.spacing = 0;
			
			_tabs = new Array();
			
			for(var i:int = 0; i < TABS; i++)
			{
				tab = new PushButton(_hbox, 0,0, "Tab " + i, tabSelected);
				tab.toggle = true;
				
				panel = new Panel(this, 0, tab.height );
				panel.visible = false;
				
				// Debugging
				new Label( panel, 0, 0, "Tab " + i );
				
				_tabs.push( {tab:tab, panel:panel} );
			}
			
			PushButton(_tabs[0].tab).selected = true;
			Panel(_tabs[0].panel).visible = true;
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Adds a new window to the bottom of the accordion.
		 * @param title The title of the new tab.
		 */
		public function addTab(title:String):void
		{
			addTabAt(title, _tabs.length);
		}
		
		public function addTabAt(title:String, index:int):void
		{
			
			var pb:PushButton;
			var p:Panel;
			
			index = Math.min(index, _tabs.length);
			index = Math.max(index, 0);
			
			pb = new PushButton(null, 0, 0, title, tabSelected );
			pb.toggle = true;
			pb.selected = false;
			
			p = new Panel( this, 0, pb.height);
			p.visible = false;
			
			// debugging content
			new Label(p, 0, 0, title );
			
			_hbox.addChildAt( pb, index );
			
			_tabs.push( {tab:pb, panel:p} );

			invalidate();
		}
		
		
		override public function draw():void
		{
			var tabW:Number = Math.round(width/_tabs.length);
			for(var i:int = 0; i < _tabs.length; i++)
			{
				_tabs[i].tab.width = tabW;
				_tabs[i].panel.setSize(width, height - _tabs[i].tab.height);
			}
			_hbox.draw();
		}
		
		/**
		 * Returns the Window at the specified index.
		 * @param index The index of the Window you want to get access to.
		 */
		public function getPanelAt(index:int):Panel
		{
			return _tabs[index].panel;
		}
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when any tab is pressed. Makes that tabs panel visible, and toggles the selected state for all the 
		 * other tabs to off. 
		 * */
		protected function tabSelected( e:Event ):void
		{
			var pb:PushButton;
			var p:Panel;
			
			var target:PushButton = e.target as PushButton;
			
			for( var i:int = 0; i < _tabs.length; i++ )
			{
				pb = _tabs[i].tab as PushButton;
				p = _tabs[i].panel as Panel;
				
				if( pb == target )
				{
					p.visible = true;
				}
				else
				{
					p.visible = false;
					pb.selected = false;
				}
			}
		}
		
		
	}
}
