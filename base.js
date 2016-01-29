//colors for different themes

var Color = {
	Red : "#e74c3c",
	RedLight : "#ea6153",
	RedDark : "#c0392b",
	// -----
	Blue : "#3498db",
	BlueLight : "#4aa3df",
	BlueDark : "#2980b9",
	// -----
	Cyan : "#1abc9c",
	CyanLight : "#1dd2af",
	CyanDark : "#16a085",
	// -----
	Black : "#34495e",
	BlackLight : "#3d566e",
	BlackDark : "#2c3e50",
	// -----
    White : "#808080",
    WhiteLight : "#808080",
    WhiteDark : "#AEAEAD",
	// -----
	Yellow : "#f1c40f",
	YellowLight : "#f2ca27",
	YellowDark : "#f39c12",
	// -----
	Magenta : "#9b59b6",
	MagentaLight : "#a66bbe",
	MagentaDark : "#8e44ad",
	// -----
	Grey : "#95a5a6",
	GreyLight : "#a3b1b2",
	GreyDark : "#7f8c8d",
	// -----
	Green : "#2ecc71",
	GreenLight : "#40d47e",
	GreenDark : "#27ae60",
	// -----
	Orange : "#e67e22",
	OrangeLight : "#e98b39",
	OrangeDark : "#d35400"
};

// Other sections
Color.Default = {
	Value : Color.Grey,
	Light :  Color.GreyLight,
	Dark :  Color.GreyDark
};
Color.Primary = {
    Value : Color.White,
    Light : Color.WhiteLight,
    Dark : Color.WhiteDark
};

Color.Success = {
	Value : Color.Green,
	Light : Color.GreenLight,
	Dark : Color.GreenDark
};

Color.Info = {
	Value : Color.Blue,
	Light : Color.BlueLight,
	Dark : Color.BlueDark
};
Color.Warning = {
	Value : Color.Orange,
	Light : Color.OrangeLight,
	Dark : Color.OrangeDark
};
Color.Danger = {
	Value : Color.Red,
	Light : Color.RedLight,
	Dark : Color.RedDark
};
Color.Inversed = {
	Value : Color.Black,
	Light : Color.BlackLight,
	Dark : Color.BlackDark
};
Color.Disabled = {
	Value : Color.WhiteDark,
	Light : Color.WhiteDark,
	Dark : Color.WhiteDark
};

Color.Background = {
    Value : "#eff0f2",
    Dark : Color.Black
};

var Font = {
    family : "Ubuntu"
};

var Utils = {
    formatTime : function(milisecs){
        var totalSeconds = milisecs/1000|0;
        var hours = totalSeconds/3600|0;
        if (hours>0){
            if (hours.toString().length == 1){
                hours = "0" + hours
            }
        } else {
            hours = ""
        }


        totalSeconds = totalSeconds%3600;
        var minutes = totalSeconds/60|0;
        if (minutes.toString().length == 1){
            minutes = "0" + minutes
        }
        var seconds = totalSeconds%60;
        if (seconds.toString().length == 1){
            seconds = "0" + seconds
        }
        if (hours.length>0){
            return hours + ":" + minutes + ":" + seconds
        } else {
            return minutes + ":" + seconds
        }


    }
}

var htmlEscape = function(html) {
    return String(html)
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
};



