package backend;


#if cpp
@:cppFileCode('#include <thread>')
#end
class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		//trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		if(NativeFileSystem.exists(path)) daList = NativeFileSystem.getContent(path);
		return daList != null ? listFromString(daList) : [];
	}

	/**
	 * Return string with first character uppercase'd, rest lowercase'd
	 * @param	str
	 * @return
	 */
	 inline public static function FUL(str:String):String
		{
			return str.substr(0, 1).toUpperCase() + str.substr(1, str.length - 1).toLowerCase();
		}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
			return Math.floor(value);

		return Math.floor(value * Math.pow(10, decimals)) / Math.pow(10, decimals);
	}
	#if linux
	public static function sortAlphabetically(list:Array<String>):Array<String> {
		if (list == null) return [];

		list.sort((a, b) -> {
			var upperA = a.toUpperCase();
			var upperB = b.toUpperCase();
			
			return upperA < upperB ? -1 : upperA > upperB ? 1 : 0;
		});
		return list;
	}
	#end

	public static function getSongDuration(musicTime:Float, musicLength:Float, precision:Int = 0):String
	{
		final secondsMax:Int = Math.floor((musicLength - musicTime) / 1000); // 1 second = 1000 miliseconds
		var secs:String = '' + Math.floor(secondsMax) % 60;
		var mins:String = "" + Math.floor(secondsMax / 60) % 60;
		final hour:String = '' + Math.floor(secondsMax / 3600) % 24;

		if (secs.length < 2)
			secs = '0' + secs;

		var shit:String = mins + ":" + secs;
		if (hour != "0")
		{
			if (mins.length < 2)
				mins = "0" + mins;
			shit = hour + ":" + mins + ":" + secs;
		}
		if (precision > 0)
		{
			var secondsForMS:Float = ((musicLength - musicTime) / 1000) % 60;
			var seconds:Int = Std.int((secondsForMS - Std.int(secondsForMS)) * Math.pow(10, precision));
			shit += ".";
			shit += seconds;
		}
		return shit;
	}

	public static function formatTime(musicTime:Float, precision:Int = 0):String
	{
		var secs:String = '' + Math.floor(musicTime / 1000) % 60;
		var mins:String = "" + Math.floor(musicTime / 1000 / 60) % 60;
		var hour:String = '' + Math.floor((musicTime / 1000 / 3600)) % 24;
		var days:String = '' + Math.floor((musicTime / 1000 / 86400)) % 7;
		var weeks:String = '' + Math.floor((musicTime / 1000 / (86400 * 7)));

		if (secs.length < 2 && Math.floor((musicTime / 1000 / 86400)) == 0)
			secs = '0' + secs;

		var shit:String = mins + ":" + secs;
		if (Math.floor((musicTime / 1000 / 3600)) != 0 && Math.floor((musicTime / 1000 / 86400)) == 0)
		{
			if (mins.length < 2)
				mins = "0" + mins;
			shit = hour + ":" + mins + ":" + secs;
		}
		if (Math.floor((musicTime / 1000 / 86400)) != 0 && Math.floor((musicTime / 1000 / (86400 * 7))) == 0)
		{
			shit = days + 'd ' + hour + 'h ' + mins + "m " + secs + 's';
		}
		if (Math.floor((musicTime / 1000 / (86400 * 7))) != 0)
		{
			shit = weeks + 'w ' + days + 'd ' + hour + 'h ' + mins + "m " + secs + 's';
		}
		if (precision > 0)
		{
			var secondsForMS:Float = (musicTime / 1000) % 60;
			var seconds:Int = Std.int((secondsForMS - Std.int(secondsForMS)) * Math.pow(10, precision));
			shit += ".";
			if (precision > 1 && Std.string(seconds).length < precision)
			{
				var zerosToAdd:Int = precision - Std.string(seconds).length;
				for (i in 0...zerosToAdd)
					shit += '0';
			}
			shit += seconds;
		}
		return shit;
	}
	
	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth)
		{
			for(row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:FlxColor = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel.alphaFloat > 0.05)
				{
					colorOfThisPixel = FlxColor.fromRGB(colorOfThisPixel.red, colorOfThisPixel.green, colorOfThisPixel.blue, 255);
					var count:Int = countByColor.exists(colorOfThisPixel) ? countByColor[colorOfThisPixel] : 0;
					countByColor[colorOfThisPixel] = count + 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for(key => count in countByColor)
		{
			if(count >= maxCount)
			{
				maxCount = count;
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	inline public static function openFolder(folder:String, absolute:Bool = false) {
		#if sys
			if(!absolute) folder =  Sys.getCwd() + '$folder';

			folder = folder.replace('/', '\\');
			if(folder.endsWith('/')) folder.substr(0, folder.length - 1);

			#if linux
			var command:String = '/usr/bin/xdg-open';
			#else
			var command:String = 'explorer.exe';
			#end
			Sys.command(command, [folder]);
			trace('$command $folder');
		#else
			FlxG.log.error("Platform is not supported for CoolUtil.openFolder");
		#end
	}

	/**
		Helper Function to Fix Save Files for Flixel 5

		-- EDIT: [November 29, 2023] --

		this function is used to get the save path, period.
		since newer flixel versions are being enforced anyways.
		@crowplexus
	**/
	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		final company:String = FlxG.stage.application.meta.get('company');
		// #if (flixel < "5.0.0") return company; #else
		return '${company}/${flixel.util.FlxSave.validate("PsychEngine")}'; //! hardcoding for backwards compatibility
		// #end
	}

	public static function setTextBorderFromString(text:FlxText, border:String)
	{
		switch(border.toLowerCase().trim())
		{
			case 'shadow':
				text.borderStyle = SHADOW;
			case 'outline':
				text.borderStyle = OUTLINE;
			case 'outline_fast', 'outlinefast':
				text.borderStyle = OUTLINE_FAST;
			default:
				text.borderStyle = NONE;
		}
	}

	public static function showPopUp(message:String, title:String):Void
	{
		#if android
		AndroidTools.showAlertDialog(title, message, {name: "OK", func: null}, null);
		#else
		FlxG.stage.window.alert(message, title);
		#end
	}

	#if cpp
    @:functionCode('
        return std::thread::hardware_concurrency();
    ')
	#end
    public static function getCPUThreadsCount():Int
    {
        return 1;
    }
}