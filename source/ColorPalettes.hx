package source;

import funkin.backend.system.Logs;
using StringTools;

public class ColorPalettes {
    /* [name].palette
    key rrggbb
    key rrggbb
    */

    public static function parseFromString(str:String):Map<String, Int> {
        if (str == "") return null;

        var toReturn:Map<String, Int> = getDefault();

        for (line in str.split("\n")) {
            if (line.trim() == "") continue;
            if (line.trim().charAt(0) == "#") continue;
            if (line.indexOf("#") != -1) line = line.substr(0, line.indexOf("#")).trim();

            var leSplit:Array<String> = line.split(" ");

            if (FlxColor.fromString("#"+leSplit[1]) == null) {
                Logs.warn("Can\'t parse " + leSplit[1] + " for key " + leSplit[0] + ".");

                if (getDefault().exists(leSplit[0])) {
                    Logs.info("Key exists in default palette, using that value instead.");
                } else {
                    Logs.warn("Key does not exist in default palette. Ignoring.");
                }
                continue;
            }

            toReturn.set(leSplit[0], FlxColor.fromString("#"+leSplit[1]));
        }

        return toReturn;
    }

    public static function parseFromPaletteFile(nameWithoutExtensionsHopefully:String):Map<String, Int> {
        var filePath:String = ClefUtils.tryGetFileFromAllLoadedMods("palettes/" + nameWithoutExtensionsHopefully + ".palette");
        try {
            var fileContent:String = filePath;
            return parseFromString(fileContent);
        } catch (e:Exception) {
            Logs.warn("Failed to parse file: " + e);
        }
        return getDefault();
    }


    public static function getDefault():Map<String, Int> {
        var colorPalette:Map<String, Int> = [
            "Accent"         => 0xfffdfdfd,
            "Outline"        => 0xff000000,
            "Hits_Marvelous" => 0xffff88aa,
            "Hits_Perfect"   => 0xffffffaa,
            "Hits_Great"     => 0xffaaff88,
            "Hits_Good"      => 0xff88aaff,
            "Hits_Bad"       => 0xff4488aa,
            "Hits_Miss"      => 0xff442200,
        ];

        return colorPalette;
    }
}
