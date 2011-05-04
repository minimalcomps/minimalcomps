/**
 * <p>Original Author:  jessefreeman</p>
 * <p>Class File: PropertyMapUtil.as</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 *
 * <p>Revisions<br/>
 *        1.0.0  Initial version Feb 11, 2010</p>
 *
 */

package com.flashartofwar.fcss.utils
{
    import com.flashartofwar.fcss.objects.PropertyMapObject;

    import flash.utils.Dictionary;
    import flash.utils.describeType;

    public class PropertyMapUtil
    {
        protected static var cachedPropertyMaps:Dictionary = new Dictionary(true);

        /**
         *
         * @param target
         * @return
         *
         */
        public static function propertyMap(target:Object):PropertyMapObject
        {

            var propMap:PropertyMapObject = new PropertyMapObject();

            var classXML:XML = scan(target);
            var className:String = classXML.@name;

            if (!cachedPropertyMaps[className])
            {
                var list:XMLList = classXML..*.((name() == "accessor") || (name() == "variable"));

                var item:XML;
                for each (item in list)
                {
                    var itemName:String = item.name().toString();

                    switch (itemName)
                    {
                        case "variable":
                            propMap[item.@name.toString()] = item.@type.toString();
							
                            break;
                        case "accessor":
                            var access:String = item.@access;
                            if ((access == "readwrite") || (access == "writeonly"))
                            {
                                propMap[item.@name.toString()] = item.@type.toString();
                            }
                            break;
                    }
                    cachedPropertyMaps[className] = propMap;
                }
            }

            else
            {
                propMap = cachedPropertyMaps[className];
            }

            return propMap.clone();
        }

        /**
         *
         * @param target
         * @return
         *
         */
        private static function scan(target:Object):XML
        {
            var classXML:XML = describeType(target);
            return classXML;
        }
    }
}