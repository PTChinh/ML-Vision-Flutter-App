import 'dart:io';

import 'package:flutter/material.dart';
import '../blocs/goals_bloc_provider.dart';


class AddGoalScreen extends StatefulWidget {
  final String _emailAddress;

  AddGoalScreen(this._emailAddress);

  @override
  AddGoalsState createState() {
    return AddGoalsState();
  }
}

class AddGoalsState extends State<AddGoalScreen> {
  GoalsBloc _bloc;
  TextEditingController goalController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = GoalsBlocProvider.of(context);
  }

  @override
  void dispose() {
    goalController.dispose();
    nameController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  //Handing back press
  Future<bool> _onWillPop() {
    Navigator.pop(context, false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Goal",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment(0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              nameField(),
              Container(margin: EdgeInsets.only(top: 1.0, bottom: 5.0)),
              goalField(),
              Container(margin: EdgeInsets.only(top: 5.0, bottom: 5.0)),
              buttons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return StreamBuilder(
        stream: _bloc.name,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          nameController.value = nameController.value.copyWith(text: snapshot.data);
          return TextField(
            controller: nameController,
            onChanged: _bloc.changeName,
            decoration: InputDecoration(
                hintText: "Enter name", errorText: snapshot.error),
          );
        });
  }

  Widget goalField() {
    return StreamBuilder(
        stream: _bloc.goalMessage,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          goalController.value = goalController.value.copyWith(text: snapshot.data);
          return TextField(
            controller: goalController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            onChanged: _bloc.changeGoalMessage,
            decoration: InputDecoration(
                hintText: "Enter your goal here", errorText: snapshot.error),
          );
        });
  }

  Widget buttons() {
    return StreamBuilder(
        stream: _bloc.showProgress,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                submitButton(),
                Container(margin: EdgeInsets.only(left: 5.0, right: 5.0)),
                scanButton(),
              ],
            );
          } else {
            if (!snapshot.data) {
              //hide progress bar
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  submitButton(),
                  Container(margin: EdgeInsets.only(left: 5.0, right: 5.0)),
                  scanButton(),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }
        });
  }

  Widget submitButton() {
    return StreamBuilder (
      stream: _bloc.name,
      builder: (BuildContext context1, AsyncSnapshot<String> snapshot1) {
        return StreamBuilder (
            stream: _bloc.goalMessage,
            builder: (BuildContext context2, AsyncSnapshot<String> snapshot2) {
              return RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Text("Submit"),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: (snapshot1.hasData && snapshot2.hasData) ? () {
                  _bloc.submit(widget._emailAddress);
                } : null,
              );
            }
        );
      }
    );
  }

  Widget scanButton() {
    return RaisedButton.icon(
        icon: Icon(Icons.add_a_photo),
        label: Text("Scan Goal"),
        textColor: Colors.white,
        color: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          _bloc.getImage();
        });
  }

}
