import 'dart:convert';

import 'package:flutter/material.dart';
import '../utils/utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String finalCity;
  Future goToNextScreen() async{
    Map results = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){

      return GetCity();

    }));
    if(results != null && results.containsKey('info')){
//      print("!st secreen says ${results['info']}");
    finalCity=results['info'];


    }
    else{
      finalCity=util.defaultCity;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(

        child:
        Scaffold(
        appBar: AppBar(
        title: Text("KLIMATIC"),
    centerTitle: true,
    backgroundColor: Colors.indigoAccent,
    actions: <Widget>[
    IconButton(
    icon: Icon(Icons.menu), onPressed:()=>goToNextScreen())
    ],
    ),
    body:
    Stack(children: <Widget>[
    Image.asset("images/umbrella.png",
    fit: BoxFit.fitWidth,
    width: 450.0,
    ),
    Container(
    alignment: Alignment.topRight,
    margin: EdgeInsets.fromLTRB(0.0, 10.0, 15.0, 0.0),
    child: Text("${finalCity == null? util.defaultCity: finalCity}", style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w300,
    color: Colors.white
    ),),
    ),

    Container(
    alignment: Alignment.center,
    margin:  EdgeInsets.fromLTRB(130.0, 130.0, 0.0 , 15.0),
    child: Image.asset("images/light_rain.png"),

    ),

     updateWeather("${finalCity == null? util.defaultCity: finalCity}")


    ],
    ),

    )
    );
  }

  Future<Map> getWeather(String appID, String city) async {
    String apiURL = "https://api.openweathermap.org/data/2.5/weather?q="
        "$city&appid=$appID&units=metric";
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }
  Widget updateWeather(String city){

    return FutureBuilder(
        future: getWeather(util.apiKey, city==null?city=util.defaultCity:city),
        builder: (BuildContext content,AsyncSnapshot<Map> snapshot){

          if(snapshot.hasData){
            Map content=snapshot.data;
            return new Container(

              margin: EdgeInsets.fromLTRB(50.0, 280.0, 0.0 , 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  ListTile(
                    title: Text(content['main']['temp'].toString()+" °C\n",style: TextStyle (
                      fontSize: 40.0,color:Colors.white,
                      fontWeight: FontWeight.w300
                    ),),
                    subtitle:  Text("Humidity:"+content['main']['humidity'].toString()+" °C\n",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                      ),),
                  ),

                ],
              ),
            );

          }
          else return Container();

        });
      // return Container();

  }
}
class GetCity extends StatefulWidget {
  @override
  _GetCityState createState() => _GetCityState();
}

class _GetCityState extends State<GetCity> {
  final formKey = GlobalKey<FormState>();
  var cityController = new TextEditingController();
  bool _hasInputError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change City"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: <Widget>[

          Image.asset("images/white_snow.png",
            width:450.0 ,
            height: 550.0,
            fit: BoxFit.fill,),
          Container(
            alignment: Alignment.topCenter,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: cityController,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please Enter A City";
                        }
                      },




                      decoration: InputDecoration(
                          labelText: "City",
                          errorText: _hasInputError ? "Please Enter City" : null,
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlatButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Update",style: TextStyle(
                            fontSize: 25.0
                        ),),
                      ),
                      color: Colors.redAccent,
                      onPressed: () {
                        if(!formKey.currentState.validate()){
                          return ;
                        }
                        Navigator.pop(context,

                            {
                              'info': cityController.text == null ? util
                                  .defaultCity : cityController.text
                            });

                      }
    ),
                  )
                ],


            ),
          )


      ),
      ]
    ),
    );
  }
}






