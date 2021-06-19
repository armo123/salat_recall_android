// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(
      MaterialApp(
        home: HomePage(),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  String _locale = 'ar';
  HijriCalendar _hidjriDate = new HijriCalendar.now();
  final coordinates = Coordinates(36.819713, 03.860139);
  final params = CalculationMethod.muslim_world_league.getParameters();
  String _date = DateFormat("dd MMMM yyyy").format(DateTime.now());
  dynamic _fajr;
  dynamic _shourouk;
  dynamic _dhuhr;
  dynamic _asr;
  dynamic _maghrib;
  dynamic _isha;
  dynamic _now;
  final _url = "audio/adhan.wav";
  String _currentPrayer = "";
  String _nextPrayer = "";
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  Widget build(BuildContext context) {
    HijriCalendar.setLocal(_locale);
    _startTimer();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF21254A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(colors: <Color>[
                        Color(0xFF8413B8),
                        Color(0xFF7E1EA3),
                        Color(0xFF6B1991),
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          _hidjriDate.toFormat("dd MMMM yyyy"),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text(_currentPrayer ??= "",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(_nextPrayer ??= "",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  color: Color(0xFF731C9B),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF131035),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                margin: EdgeInsets.only(left: 14, right: 14, bottom: 50),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'الشروق',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                margin: EdgeInsets.only(bottom: 30),
                                child: Text(
                                  _shourouk ??= "",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'الفجر',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  _fajr ??= "",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'الظهر',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  _dhuhr ??= "",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'العصر',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 30),
                                padding: EdgeInsets.only(right: 10),
                                child: Text(_asr ??= "",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  'العشاء',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  _isha ??= "",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'المغرب',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  _maghrib ??= "",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _playAudio() async {
    if (audioCache.loadedFiles.isEmpty) {
      audioCache.play('audio/adhan.wav');
    }
  }

  void _startTimer() {
    final _prayerTimes = PrayerTimes.today(coordinates, params);
    Timer.periodic(Duration(seconds: 1), (timer) {
      _fajr = DateFormat.Hm().format(_prayerTimes.fajr);
      _shourouk = DateFormat.Hm().format(_prayerTimes.sunrise);
      _dhuhr = DateFormat.Hm().format(_prayerTimes.dhuhr);
      _asr = DateFormat.Hm().format(_prayerTimes.asr);
      _maghrib = DateFormat.Hm().format(_prayerTimes.maghrib);
      _isha = DateFormat.Hm().format(_prayerTimes.isha);
      _now = DateFormat.Hms().format(DateTime.now());

      switch (_prayerTimes.currentPrayer().toString()) {
        case 'Prayer.fajr':
          _currentPrayer = 'الفجر';
          break;
        case 'Prayer.sunrise':
          _currentPrayer = 'الشروق';
          break;
        case 'Prayer.dhuhr':
          _currentPrayer = 'الظهر';
          break;
        case 'Prayer.asr':
          _currentPrayer = 'العصر';
          break;
        case 'Prayer.maghrib':
          _currentPrayer = 'المغرب';
          break;
        case 'Prayer.isha':
          _currentPrayer = 'العشاء';
          break;
      }

      switch (_prayerTimes.nextPrayer().toString()) {
        case 'Prayer.fajr':
          _nextPrayer = 'الفجر';
          break;
        case 'Prayer.sunrise':
          _nextPrayer = 'الشروق';
          break;
        case 'Prayer.dhuhr':
          _nextPrayer = 'الظهر';
          break;
        case 'Prayer.asr':
          _nextPrayer = 'العصر';
          break;
        case 'Prayer.maghrib':
          _nextPrayer = 'المغرب';
          break;
        case 'Prayer.isha':
          _nextPrayer = 'العشاء';
          break;
      }

      if (_fajr + ':00' == _now) {
        _playAudio();
      }
      if (_dhuhr + ':00' == _now) {
        _playAudio();
      }
      if (_asr + ':00' == _now) {
        _playAudio();
      }
      if (_maghrib + ':00' == _now) {
        _playAudio();
      }
      if (_isha + ':00' == _now) {
        _playAudio();
      }
      setState(() {});
    });
  }
}
