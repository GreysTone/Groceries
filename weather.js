var res = new Object();
res.Time_MDHM = "10090556";
res.TimeDHM_HMS = "";

res.WeatherStr = "";

res.WindDir_Speed = "220/004";
res.CompWindDir_Speed = "";

res.Lat = "";
res.Long = "";
res.CompLat = "5L!!";
res.CompLong = "<*e7";
res.AprsSoft = "w";
res.WeatherUnit = "RSW";
res.ObjectName = "";

var wea = new Object();
wea.WindDirection = "";
wea.WindSpeed = "";
wea.Gust = "";
wea.Temp = "";
wea.RainLastHr = "";
wea.RainLast24Hr = "";
wea.RainSinceMid = "";
wea.Humidity = "";
wea.Barometric = "";
//wea.Luminosity = "";
//wea.Luminosity2 = "";
//wea.SnowfallLast24Hr = "";  //in inches
//wea.RawRainCounter = "";


var storm = new Object();
storm.StormStr = "088/036/HC/150^200/0980>090&030%040";
storm.Name = "GreysTones Storm";
storm.TimeDHM_HMS = "100045z";
storm.Lat = "";
storm.Long = "";
storm.Direction = "";
storm.Speed = "";
storm.StormType = "";
storm.SustainedWindSpeed = "";
storm.PeakWindGusts = "";
storm.CentralPressure = "";
storm.RadiusHurricaneWinds = "";
storm.RadiusTropicalStormWinds = "";
storm.RadiusWholeGale = "";


var time = new Object();
time.Type = 0;
// 0 - undefine ; 1 - DayHrMin(UTC/GMT) z ; 2 - DayHrMin(Local) / ; 3 HrMinSec(UTC/GMT) h ; 4 MonDayHrMin(UTC/GMT)
time.Month = "";
time.Day = "";
time.Hour = "";
time.Min = "";
time.Sec = "";

//Split Time
tStr = storm.TimeDHM_HMS;
if(tStr.length == 7) {
    tail = tStr.charAt(6);
    var d = new Date();
    //console.log(tail);
    switch (tail) {
        case 'z':
            time.Month = d.getUTCMonth() + 1;
            time.Day = tStr.slice(0, 2);
            time.Hour = tStr.slice(2, 4);
            time.Min = tStr.slice(4, 6);
            break;
        case '/':
            time.Month = d.getMonth() + 1;
            time.Day = tStr.slice(0, 2);
            time.Hour = tStr.slice(2, 4);
            time.Min = tStr.slice(4, 6);
            break;
        case 'h':
            time.Hour = tStr.slice(0, 2);
            time.Min = tStr.slice(2, 4);
            time.Sec = tStr.slice(4, 6);
            break;
    }
} else if(tStr.length == 8) {
    time.Type = 4;
    time.Month = tStr.slice(0, 2);
    time.Day = tStr.slice(2, 4);
    time.Hour = tStr.slice(4, 6);
    time.Min = tStr.slice(6, 8);
} else {
    console.log('Unknown Data');
}
//console.log(time);


//Split StormStr - Data
sStr = storm.StormStr;
storm.Direction = sStr.slice(0,3);
storm.Speed = sStr.slice(4,7);
storm.StormType = sStr.slice(8,10);
storm.SustainedWindSpeed = sStr.slice(11,14);       //unit - knots
storm.PeakWindGusts = sStr.slice(15,18);            //unit - knots
storm.CentralPressure = sStr.slice(19,23);
storm.RadiusHurricaneWinds = sStr.slice(24,27);
storm.RadiusTropicalStormWinds = sStr.slice(28,31);
storm.RadiusWholeGale = sStr.slice(sStr.indexOf('%')+1, sStr.indexOf('%')+4);
//console.log(storm)


res.WeatherStr = "c...s   g005t077r000p000P000h50b09900";
res.WindDir_Speed = ""; //"220/004";
res.CompWindDir_Speed = "7P";

//Split WeatherStr
wStr = res.WeatherStr;
var extraStr = new Object();
extraStr.WindDir_Speed = res.WindDir_Speed;
extraStr.CompWindDir_Speed = res.CompWindDir_Speed;

//WindDirection
wea.WindDirection = wStr.slice(wStr.indexOf('c')+1, wStr.indexOf('c')+4);       // degrees
if(wea.WindDirection == "..." || wea.WindDirection == "   ") wea.WindDirection = 0;
if(wea.WindDirection == wStr.slice(0, 3)) wea.WindDirection = 0;
if(extraStr.WindDir_Speed != "") wea.WindDirection = extraStr.WindDir_Speed.slice(0, 3);
if(extraStr.CompWindDir_Speed.charAt(0) >= '!' && extraStr.CompWindDir_Speed.charAt(0) <='z') {
    wea.WindDirection = (extraStr.CompWindDir_Speed.charCodeAt(0) - 33) * 4;
}
//WindSpeed
wea.WindSpeed = wStr.slice(wStr.indexOf('s')+1, wStr.indexOf('s')+4);           // mph
if(wea.WindSpeed == "..." || wea.WindSpeed == "   ") wea.WindSpeed = 0;
if(wea.WindSpeed == wStr.slice(0, 3)) wea.WindSpeed = 0;
if(extraStr.WindDir_Speed != "") wea.WindSpeed = extraStr.WindDir_Speed.slice(4, 7);
if(extraStr.CompWindDir_Speed.charAt(0) >= '!' && extraStr.CompWindDir_Speed.charAt(0) <='z') {
    pow = 1.00;  eFlag = extraStr.CompWindDir_Speed.charCodeAt(1) - 33;
    for(i=1; i<= eFlag; i++) pow = pow * 1.08;
    wea.WindSpeed = pow - 1;
}

//Latitude
wea.Lat = res.Lat;
if(res.CompLat != "") {
    y1 = (res.CompLat.charCodeAt(0)-33) * (91*91*91);
    y2 = (res.CompLat.charCodeAt(1)-33) * (91*91);
    y3 = (res.CompLat.charCodeAt(2)-33) * (91);
    y4 = (res.CompLat.charCodeAt(3)-33) * (1);
    wea.Lat =  90 - (y1 + y2 + y3 + y4) / 380926;
}

//Longtitude
wea.Long = res.Long;
if(res.CompLong != "") {
    x1 = (res.CompLong.charCodeAt(0)-33) * (91*91*91);
    x2 = (res.CompLong.charCodeAt(1)-33) * (91*91);
    x3 = (res.CompLong.charCodeAt(2)-33) * (91);
    x4 = (res.CompLong.charCodeAt(3)-33) * (1);
    wea.Long =  -180 + (x1 + x2 + x3 + x4) / 190463;
}

//AprsSoftware & WeatherUnit
res.AprsSoft = "M";
aStr = res.AprsSoft;
res.WeatherUnit = "Upkm";
uStr = res.WeatherUnit;
switch (aStr) {
    case "d":
        wea.AprsSoft = "APRSdos";
        break;
    case "M":
        wea.AprsSoft = "MacAPRS";
        break;
    case "P":
        wea.AprsSoft = "pocketAPRS";
        break;
    case "S":
        wea.AprsSoft = "APRS+SA";
        break;
    case "W":
        wea.AprsSoft = "WinAPRS";
        break;
    case "X":
        wea.AprsSoft = "X-APRS (Linux)";
        break;
    default:
        wea.AprsSoft = res.AprsSoft;
}

switch (uStr) {
    case "Dvs":
        wea.WeatherUnit = "Davis";
        break;
    case "HKT":
        wea.WeatherUnit = "Heathkit";
        break;
    case "PIC":
        wea.WeatherUnit = "PIC device";
        break;
    case "RSW":
        wea.WeatherUnit = "Radio Shack";
        break;
    case "￼U-II":
        wea.WeatherUnit = "Original Ultimeter U-II (auto mode)";
        break;
    case "￼￼￼U2R":
        wea.WeatherUnit = "Original Ultimeter U-II (remote mode)";
        break;
    case "￼U2k￼￼￼":
        wea.WeatherUnit = "Ultimeter 500/2000";
        break;
    case "U2kr":
        wea.WeatherUnit = "Remote Ultimeter logger";
        break;
    case "￼U5￼￼￼":
        wea.WeatherUnit = "Ultimeter 500";
        break;
    case "Upkm":
        wea.WeatherUnit = "Remote Ultimeter packet mode";
        break;
    default:
        wea.WeatherUnit = res.WeatherUnit;
}


//Gust
wea.Gust = wStr.slice(wStr.indexOf('g')+1, wStr.indexOf('g')+4);                // mph (peak speed in the last 5min)
if(wea.Gust == "..." || wea.Gust == "   ") wea.Gust = 0;
if(wea.Gust == wStr.slice(0, 3)) wea.Gust = 0;
//Temp
wea.Temp = wStr.slice(wStr.indexOf('t')+1, wStr.indexOf('t')+4);                // degrees Fahrenheit
if(wea.Temp == "..." || wea.Temp == "   ") wea.Temp = 0;
if(wea.Temp == wStr.slice(0, 3)) wea.Temp = 0;
//RainLastHr
wea.RainLastHr = wStr.slice(wStr.indexOf('r')+1, wStr.indexOf('r')+4);          // hundredths of an inch
if(wea.v == wStr.slice(0, 3)) wea.v = 0;
//RainLast24Hr
wea.RainLast24Hr = wStr.slice(wStr.indexOf('p')+1, wStr.indexOf('p')+4);
if(wea.RainLast24Hr == wStr.slice(0, 3)) wea.RainLast24Hr = 0;
//RainSinceMid
wea.RainSinceMid = wStr.slice(wStr.indexOf('P')+1, wStr.indexOf('P')+4);
if(wea.RainSinceMid == wStr.slice(0, 3)) wea.RainSinceMid = 0;
//Humidity
wea.Humidity = wStr.slice(wStr.indexOf('h')+1, wStr.indexOf('h')+3);            // in %.00 = 100%
if(wea.Humidity == wStr.slice(0, 2)) wea.Humidity = 0;
//Barometric
wea.Barometric = wStr.slice(wStr.indexOf('b')+1, wStr.indexOf('b')+5);
if(wea.Barometric == wStr.slice(0, 4)) wea.Barometric = 0;
//wea.Luminosity = wStr.slice(wStr.indexOf('L')+1, wStr.indexOf('L')+4);          // in watts per meter^2 <= 999
//wea.Luminosity2 = wStr.slice(wStr.indexOf('l')+1, wStr.indexOf('l')+4);
//wea.SnowfallLast24Hr = wStr.slice(wStr.indexOf('s')+1, wStr.indexOf('s')+4);  //in inches
//wea.RawRainCounter = wStr.slice(wStr.indexOf('#')+1, wStr.indexOf('#')+4);
console.log(wea);
