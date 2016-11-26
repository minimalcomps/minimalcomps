/**
 * TreeList.as
 * Adam Harte
 * version 0.9.10
 * 
 * A scrolling list of selectable items, with expandable sub-items. 
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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TreeList extends List 
	{
		protected var _allItems:Array;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this TreeList.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param items A multi-dimentional array of items to display in the tree list. Objects with label and optional items array property.
		 */
		public function TreeList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, items:Array=null) 
		{
			if(items != null)
			{
				_allItems = items;
			}
			else
			{
				_allItems = new Array();
				_items = new Array();
			}
			
			super(parent, xpos, ypos, items);
		}
		
		/**
		 * Initilizes the component.
		 */
		protected override function init() : void
		{
			_listItemClass = TreeListItem;
			formatItems();
			updateItems();
			
			super.init();
		}
		
		protected function updateItems():void 
		{
			_items = new Array();
			updateBranch(_allItems);
			invalidate();
		}
		
		protected function updateBranch(value:Array, startIndex:int=0):uint 
		{
			var offset:uint = startIndex;
			for (var i:int = 0; i < value.length; i++) 
			{
				_items.push(value[i]);
				
				if (value[i].hasOwnProperty('expanded') && value[i].expanded) 
				{
					if (value[i].hasOwnProperty('items') && value[i].items is Array) 
					{
						offset = updateBranch(value[i].items, offset);
					}
				}
			}
			return offset;
		}
		
		/**
		 * Added extra fields to each items data object.
		 * @param	value
		 * @param	startIndex
		 * @param	indent
		 * @return
		 */
		protected function formatItems():void
		{
			formatBranch(_allItems);
		}
		
		protected function formatBranch(value:Array, startIndex:int=0, indent:int=0):uint 
		{
			var offset:uint = startIndex;
			for (var i:uint = 0; i < value.length; i++) 
			{
				value[i].index = offset;
				value[i].indent = indent;
				if (!value[i].hasOwnProperty('expanded')) value[i].expanded = true;
				offset++;
				
				if (value[i].hasOwnProperty('items') && value[i].items is Array) 
				{
					offset = formatBranch(value[i].items, offset, indent+1);
				}
			}
			return offset;
		}
		
		protected function expandCollapseBranch(value:Array, startIndex:int=0, expand:Boolean=true):uint 
		{
			var offset:uint = startIndex;
			for (var i:uint = 0; i < value.length; i++) 
			{
				value[i].expanded = expand;
				offset++;
				
				if (value[i].hasOwnProperty('items') && value[i].items is Array) 
				{
					offset = expandCollapseBranch(value[i].items, offset, expand);
				}
			}
			return offset;
		}
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		public function expandAll():void 
		{
			expandCollapseBranch(_allItems, 0, true);
			refresh();
			
			invalidate();
		}
		
		public function collapseAll():void 
		{
			expandCollapseBranch(_allItems, 0, false);
			refresh();
			
			invalidate();
		}
		
		public function expandItem(value:Object):void 
		{
			value.expanded = true;
			refresh();
			
			invalidate();
		}
		
		public function collapseItem(value:Object):void 
		{
			value.expanded = false;
			refresh();
			
			invalidate();
		}
		
		public function toggleExpandItem(value:Object):void 
		{
			value.expanded = !value.expanded;
			refresh();
			
			invalidate();
		}
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when a user selects an item in the list.
		 */
		protected override function onSelect(event:Event):void
		{
			if(!(event.target is ListItem)) return;
			
			super.onSelect(event);
			
			if (TreeListItem(event.target).data.hasOwnProperty('items')) 
			{
				TreeListItem(event.target).data.expanded = !TreeListItem(event.target).data.expanded;
				
				refresh();
			}
		}
		
		protected function refresh():void 
		{
			updateItems();
				
			var numItems:int = Math.ceil(_height / _listItemHeight);
			numItems = Math.min(numItems, _items.length);
			numItems = Math.max(numItems, 1);
			if (_itemHolder.numChildren != numItems) 
			{
				makeListItems();
			}
			
			fillItems();
			scrollToSelection();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the list of items to be shown.
		 */
		public override function set items(value:Array):void
		{
			_allItems = value;
			
			formatItems();
			updateItems();
			
			invalidate();
		}
	}

}