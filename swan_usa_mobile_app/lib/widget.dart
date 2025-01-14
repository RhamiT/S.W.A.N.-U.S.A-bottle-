import 'dart:ffi';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

//classes
import "user.dart";
import "bottle.dart";

class myWidget {
  // variables

  // functions
  Widget battery(int charge, String data) {
    return Container(
      color: Color(0xFFFFFFFF),
      // height: 250,
      // width: 250,
      child: Scaffold(
          appBar: AppBar(
            title: Text("charge"),
            backgroundColor: Color.fromARGB(238, 233, 233, 211),
            centerTitle: true,
          ),
          body: Row(
            children: [
              Expanded(child: Text(charge.toString() + "%\n" + data)),
              Expanded(
                  //Update image to be from assets
                  child: Image.network(
                      "https://imgs.search.brave.com/0O8YUV15rfsulnoQ-VQ5g1PDZTk0rQKVY-Iuh_MXlCI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG40/Lmljb25maW5kZXIu/Y29tL2RhdGEvaWNv/bnMvc2ltcGxlLWJh/dHRlcnktbGluaWNv/bnMvMTAwL2JhdHRl/cnlfY2hhcmdpbmdf/dmVydGljYWwtNTEy/LnBuZw"))
            ],
          )),
    );
  }

  // Widget loadData(Strings data) {}
  Widget nutrition(String data) {
    return Container(
        color: Color(0xFFFFFFFF),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xB3FFF2F2),
            title: Text("Nutrition"),
            centerTitle: true,
          ),
          body: Text(data),
        ));
  }

  Widget beverageLvl(String data, int bvgLvl) {
    return Container(
      color: Color(0xFFFFFFFF),
      // height: 250,
      // width: 250,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Bottle"),
            backgroundColor: Color(0xEDE9E9D3),
            centerTitle: true,
          ),
          body: Row(
            children: [
              Expanded(child: Text(data)),
              Expanded(
                  //Update image to be from assets
                  child: Image.network(
                      "https://imgs.search.brave.com/wc30-nf_33-f_jnUxVzxwrWO3X3mgTtARJ8o72iNw0A/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzA5LzMxLzQ2LzE5/LzM2MF9GXzkzMTQ2/MTk0N195T1dadHlE/OFZpS3ljUWVzVUlX/a2hUTllYdVh5TXl5/OS5qcGc"))
            ],
          )),
    );
  }

  Widget Graph(String src) {
    return Container(
      color: Color(0xB3FFF2F2),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Graph"),
          backgroundColor: Color(0xFFFFFFFF),
          centerTitle: true,
        ),
        body: Row(
          children: [
            Expanded(child: Image.network(src)), // graph view
            Expanded(child: Text("add selector later")) // footer (selector)
          ],
        ),
      ),
    );
  }

  Widget drinkData(String data) {
    return Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Drink Data"),
            backgroundColor: Color(0xB7FAE8E8),
            centerTitle: true,
          ),
          body: Text(data),
        ));
  }

  // Widget GrabWidget() {
  //   return Container(
  //     color: Color(0xFFFFFEFF),
  //     child: Scaffold(
  //       appBar: AppBar(),
  //       body: Row(
  //         children: [
  //           Expanded(child: Text("load data")),
  //           Expanded(child: DropdownButton(
  //             items: items,
  //             onChanged: (){}))
  //           ),
  //         ],
  //       )
  //     ),
  //   );
  // }

  Widget test(Color c, String s) {
    return AppBar(
      backgroundColor: c,
      title: Text(s),
    );
  }

  Widget loadWidget(int code) {
    // TODO: Add check for code and call to proper
    return test(Color(0xFFFF4141), "Error");
  }
}
