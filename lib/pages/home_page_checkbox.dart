import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/colors.dart';
import '../pages/add_color_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool allStatus = false;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    print("did change");
    var provider = Provider.of<MultiColor>(context);
    if (isInit) {
      provider.intializeData();
      isInit = !isInit;
    }
    allStatus = provider.checkAllStatus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var colorsClass = Provider.of<MultiColor>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, AddColorPage.routeName),
          ),
        ],
      ),
      body: colorsClass.colors.isEmpty
          ? const Center(
              child: Text(
                "No Data",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            )
          : ListView(
              children: [
                CheckboxListTile(
                  value: allStatus,
                  onChanged: (value) {
                    print(value);
                    allStatus = value!;
                    colorsClass.selectAll(allStatus);
                  },
                  title: const Text("Select all colors"),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const Divider(),
                ...colorsClass.colors
                    .map(
                      (e) => ChangeNotifierProvider.value(
                        value: e,
                        builder: (context, child) => CheckboxListTile(
                          value: e.status,
                          onChanged: (status) {
                            print(status);
                            colorsClass.updateStatus(e.id, status!).then(
                                  (value) => value
                                      ? setState(
                                          () {
                                            e.toogleStatus();
                                          },
                                        )
                                      : null,
                                );

                            allStatus = colorsClass.checkAllStatus();
                          },
                          title: Text(e.title),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 40),
                          secondary: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              colorsClass.deleteColor(e.id);
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
    );
  }
}
