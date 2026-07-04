package source;

import funkin.backend.assets.ModsFolder;

import sys.io.File;
import sys.FileSystem;


/**
 * Various utilities Claire uses in her scripts.
 *
 * This is a parallel to her `base.lua` script for Psych 0.7.3, just in Codename HScript.
 */
class ClefUtils {
	/**
	 * Creates a rectangle of a specified size at the specified coordinates.
	 * @param x The X position of this rectangle.
	 * @param y The Y position of this rectangle.
	 * @param width The width of this rectangle.
	 * @param height The height of this rectangle.
	 * @param color The color of this rectangle in the 0xAARRGGBB format.
	 * @param solid Should this be a solid? This substitutes `makeGraphic` with CNE's `makeSolid` function.
	 */
	public static function makeRect(x:Float, y:Float, width:Float, height:Float, color:Int, solid:Bool = false):FlxSprite {
		if (solid)
			return new FlxSprite(x, y).makeGraphic(width, height, color);

		return new FlxSprite(x, y).makeSolid(width, height, color);
	}

	/**
	 * Creates a text of a specified size with a specified text at the specified coordinates.
	 * @param x The X position of this text.
	 * @param y The Y position of this text.
	 * @param str The string the text will have.
	 * @param size The size of the text.
	 * @param align The alignment of the text.
	 * @param outline Does this text have an outline?
	 */
	public static function makeText(x:Float, y:Float, str:String = "", size:Float = 16, align:String = "left", outline:Bool = true):FunkinText {
		var t = new FunkinText(x, y, 0, str, size, outline);
		t.antialiasing = Options.antialiasing;
		t.alignment = align;
		return t;
	}

	/**
	 * Creates a camera. There's nothing much else to it.
	 * @param autoAdd Should this camera be automatically added to `FlxG.cameras`?
	 */
	public static function makeCamera(autoAdd:Bool = false):HudCamera {
		cam = new HudCamera();
		cam.bgColor = 0x00000000;
		if (autoAdd)
			FlxG.cameras.add(cam, false);
		return cam;
	}

	/**
	 * Extracts the RGB components for a color in the 0xRRGGBB format.
	 * @param color
	 * @return Array<Int>
	 */
	public static function extractRgbChannels(color:Int):Array<Int> {
		return [(color >> 16 & 0xff), (color >> 8) & 0xff, color & 0xff];
	}

	/**
	* Scans through all loaded mods for a specified file.
	* Effectively just a glorified `Path.file` but it scans through mods and addons.
	*/
	public static function tryGetFileFromAllLoadedMods(targetPath):Null<String> {
        for (i in ModsFolder.getLoadedMods(true)) {
            for (j in ["./mods", "./addons", "./assets"]) {
                try {
                    var question:String = File.getContent(j + "/" + i + "/" + targetPath);
                    return question;
                } catch (e:Exception) {

                }
            }
        }
	}

	/**
	* Scans through all loaded mods for a folder then returns the folder's content.
	* Effectively just a glorified `Path.getFolderContent` but it scans through mods and addons.
	*/
	public static function tryGetFolderContentFromAllLoadedMods(targetPath):Null<Array<String>> {
        for (i in ModsFolder.getLoadedMods(true)) {
            for (j in ["./mods", "./addons", "./assets"]) {
                try {
                    var question:Array<String> = FileSystem.readDirectory(j + "/" + i + "/" + targetPath);
                    return question;
                } catch (e:Exception) {

                }
            }
        }
	}
}
