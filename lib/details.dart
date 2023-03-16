import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final String info;
  final List precaution, pesticides;
  const Details(
      {Key? key,
      required this.info,
      required this.precaution,
      required this.pesticides})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: const Text("Details"),
          bottom: const TabBar(
            indicatorColor: Colors.brown,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Text("Information"),
              ),
              Tab(
                child: Text("Precaution"),
              ),
              Tab(
                child: Text("Pesticides"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(info,style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
            ),
            ListView.builder(
                itemCount: precaution.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: Text((i+1).toString()),
                    title: Text(precaution[i].toString(),style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                  );
                }),
            ListView.builder(
                itemCount: pesticides.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: Text((i+1).toString()),
                    title: Text(pesticides[i].toString(),style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
