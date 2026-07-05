function new() {
    FlxG.save.data.epoch_gameplay_judge ??= 4;
    FlxG.save.data.epoch_gameplay_life  ??= true;
    FlxG.save.data.epoch_gameplay_wife  ??= true;

    FlxG.save.data.epoch_visual_vanillaElements ??= false;
}
