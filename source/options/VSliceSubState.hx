package options;
import options.Option;

class VSliceSubState extends BaseOptionsMenu {
    public function new() {
        title = Language.getPhrase("vslice_menu","V-Slice settings");
        rpcTitle = "V-Slice settings menu";

		var option:Option = new Option('Naughtyness',
			'If disabled, some "raunchy content" (such as swearing, etc.) will be disabled.',
			'vsliceNaughtyness',
			BOOL);
		addOption(option);

		var option:Option = new Option('Use Results Screen',
			'If disabled will skip showing the result screen.',
			'vsliceResults',
			BOOL);
		addOption(option);

		var option:Option = new Option('Smooth Health Bar',
			'If enabled makes health bar move more smoothly.',
			'vsliceSmoothBar',
			BOOL);
		addOption(option);

		var option:Option = new Option('Old Sustain Note Style',
			'If checked, sustain notes will react like how they did before 0.3.X.',
			'vsliceSus',
			BOOL);
		addOption(option);

		var option:Option = new Option('Use Legacy Bar',
			'Makes health bar and score text much simpler.',
			'vsliceLegacyBar',
			BOOL,);
		addOption(option);
		
		var option:Option = new Option('Special Freeplay Cards',
			'If disabled will force every character to use BF\'s card. (including pico)',
			'vsliceSpecialCards',
			BOOL);
		addOption(option);
        super();
    }
}