import source.ClefUtils;
import source.Judge;
import source.Wife;
import source.ColorPalettes;
import source.Strain;

import flixel.util.FlxStringUtil;
import flixel.text.FlxTextBorderStyle;

import Type;

using StringTools;

// Etterna bullshit (which is the main point of Epoch)
var life:Float = 50;
var dp:Dynamic = {total: 0, current: 0, ratio: 1};
var wife:Dynamic = {total: 0, score: 0};
var judgeList:Map<String, Int> = [
    "Marvelous" => 0,
    "Perfect" => 0,
    "Great" => 0,
    "Good" => 0,
    "Bad" => 0,
    "Miss" => 0,
    ];

// HUD bullshit
var ep_camera = ClefUtils.makeCamera(true);
var ep_accuracy   = ClefUtils.makeText(16, 350 - 24, "100.00%", 32, "left", true);
var ep_judgeStats = ClefUtils.makeText(16, 350, "", 16, "left", true);
var ep_judge      = ClefUtils.makeText(16, 150, "", 24, "center", true);
var ep_songDetail = ClefUtils.makeText(16, 16, "", 16, "left", true);
var ep_judgeProgress = 0;
var elements:Array<Dynamic> = [ep_accuracy, ep_judgeStats, ep_judge, ep_songDetail];

// Palette bullshit
var curPaletteIndex:Int = 0;
var palettesInRotation = [ColorPalettes.getDefault()];
var currentPalette:Map<String, Int> = null;

function postCreate() {
    currentPalette = ColorPalettes.getDefault();

    if (ClefUtils.tryGetFolderContentFromAllLoadedMods("palettes").length > 0) {
        for (p in ClefUtils.tryGetFolderContentFromAllLoadedMods("palettes")) {
            palettesInRotation.push(ColorPalettes.parseFromPaletteFile(p.substr(0, p.indexOf(".palette"))));
        }
    }

    instantiateOverlay();
}

function instantiateOverlay(isRepaint:Bool = false) {
    for (i in elements) {
        if (!isRepaint) add(i).camera = ep_camera;

        i.setFormat(
            Paths.font("Perfect DOS VGA 437 Win.ttf"),
            i.size,
            currentPalette["Accent"],
            i.alignment
        );

        i.setBorderStyle(Type.resolveEnum("flixel.text.FlxTextBorderStyle").SHADOW, currentPalette["Outline"], 1, 1);
    }

    var strain:Float = 0;
    var strainAccum:String = "";

    for (strumline in PlayState.SONG.strumLines) {
        if (strumline.type != 1) continue;

        strain = Strain.getStrainOfStrumline(strumline).average;
        strainAccum += FlxStringUtil.formatMoney(strain) + " ";
    }

    var extraInfo:String = " ";
    if (FlxG.save.data.epoch_gameplay_override != 1) extraInfo += "ScrollOverride(" + FlxG.save.data.epoch_gameplay_override + ") ";
    if (camHUD.downScroll) extraInfo += "Invert ";

    ep_songDetail.text = (PlayState.SONG.meta.displayName ?? PlayState.SONG.meta.name) + " ["+ PlayState.difficulty +"] - " + strainAccum + "\nW3 J" + FlxG.save.data.epoch_gameplay_judge + " L4" + extraInfo;
    ep_songDetail.y = ep_camera.height - 16 - ep_songDetail.height;
}

function onPlayerHit(e) {
    if (FlxG.save.data.epoch_gameplay_life) e.healthGain = 0;
    if (e.note.isSustainNote) return;

    reeval(e.note.strumTime, false);

    FlxG.sound.play(Paths.sound("editors/charter/hitsound"));
}

function postUpdate(delta) {
    for (i in [scoreTxt, missesTxt, accuracyTxt]) {
        if (!FlxG.save.data.epoch_visual_vanillaElements) i?.visible = false;
    }

    if (FlxG.keys.justPressed.TAB) {
        curPaletteIndex++;
        if (curPaletteIndex > palettesInRotation.length - 1) curPaletteIndex = 0;
        currentPalette = palettesInRotation[curPaletteIndex];
        instantiateOverlay(true);
    }

    for (i in player.members) {
        if (FlxG.save.data.epoch_gameplay_override != 1) i.scrollSpeed = FlxG.save.data.epoch_gameplay_override;
    }

    if (ep_judgeProgress < 1) ep_judgeProgress += delta * 2;
    ep_judge.scale.x = ep_judge.scale.y = 1.25 - FlxEase.quintOut(ep_judgeProgress) * 0.25;
    ep_judge.alpha = 1 -  FlxEase.quintIn(ep_judgeProgress);

    var centerpoint = 0;
    var sum = 0;

    for (i in player.members) {
        sum += i.x + i.width / 2;
    }

    centerpoint = sum / player.members.length;
    ep_judge.x = centerpoint - ep_judge.width / 2;

    if (FlxG.save.data.epoch_gameplay_life) health = life / 50;

    ep_accuracy.text = FlxStringUtil.formatMoney(wife.total == 0 ? 0 : wife.score / wife.total * 100) + "%";
    if (FlxG.save.data.epoch_gameplay_wife) accuracy = wife.total == 0 ? -1 : wife.score / wife.total;

    ep_judgeStats.text = "("+ Judge.getClearType(judgeList) + ") " + Judge.getRatingAtAccuracy((wife.total == 0 ? 0 : wife.score / wife.total) * 100);
    ep_judgeStats.text += "\n";
    ep_judgeStats.text += "\nMA    " + judgeList["Marvelous"];
    ep_judgeStats.text += "\nPR    " + judgeList["Perfect"];
    ep_judgeStats.text += "\nGR    " + judgeList["Great"];
    ep_judgeStats.text += "\nGD    " + judgeList["Good"];
    ep_judgeStats.text += "\nBD    " + judgeList["Bad"];
    ep_judgeStats.text += "\nMS    " + judgeList["Miss"];
    ep_judgeStats.text += "\n";
    ep_judgeStats.text += "\nMA    " + FlxStringUtil.formatMoney(judgeList["Perfect"] > 0 ? judgeList["Marvelous"] / judgeList["Perfect"] : 0);
    ep_judgeStats.text += "\nPA    " + FlxStringUtil.formatMoney(judgeList["Great"] > 0 ? judgeList["Perfect"] / judgeList["Great"] : 0);
}

function onPlayerMiss(e) {
    reeval(e.note.strumTime + 10000, true);

    judgeList["Miss"]++;
}

function reeval(deviation, isMiss) {
    var obj:Dynamic = Judge.evaluateHit(Conductor.songPosition - deviation, FlxG.save.data.epoch_gameplay_judge);

    var wifescore = Wife.getWifescoreAt(Math.abs(Conductor.songPosition - deviation));

    life += obj.life;
    dp.total += 2;
    dp.current += obj.dp;
    dp.ratio = dp.current / dp.total;

    wife.total += 2;
    wife.score += isMiss ? -2.75 : wifescore;

    judgeList[obj.judge]++;

    ep_judgeProgress = 0;

    ep_judge.text = "";
    ep_judge.text += "\n" + obj.judge;
    if (!isMiss) ep_judge.text += "\n" + FlxStringUtil.formatMoney(obj.delta) + "ms";
    ep_judge.text += "\n" + FlxStringUtil.formatMoney(wifescore / 2 * 100) + "%";

    if (!isMiss) ep_judge.color = currentPalette["Hits_"+ obj.judge];
}
