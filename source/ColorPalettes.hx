package source;

using StringTools;

public class ColorPalettes {
    /* [name].palette
    key rrggbb
    key rrggbb
    */

    public static function parseFromString(str:String) {
        for (line in str.split("\n")) {
            if (line.trim().charAt(0) == "#") continue;
            if (line.indexOf("#") != -1) line = line.substr(0, line.indexOf("#"));
        }
    }


    public static function getDefault():Map<String, Int> {
        var colorPalette:Map<String, Int> = [
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
