import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/brushing.dart';
import 'package:nu_parent/main.dart';
import 'package:nu_parent/timer.dart';

class BrushingInstruction extends StatefulWidget {
  final int age;
  const BrushingInstruction({Key? key, this.age = 0}) : super(key: key);

  @override
  State<BrushingInstruction> createState() => _BrushingInstructionState();
}

class _BrushingInstructionState extends State<BrushingInstruction> {
  late Future<List<Map<String, dynamic>>> brushingGroup;
  bool check = false;

  Future<List<Map<String, dynamic>>> fetchBrushingGroup() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('brushingGroups').get();

    return querySnapshot.docs.map((doc) {
      return {
        'brushing': doc['brushing'] as String,
        'image': doc['image'] as String,
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    brushingGroup =
        fetchBrushingGroup(); // Call function to fetch data from Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Vector-2.png'),
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: brushingGroup,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
              ); // Show loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              return ListView(
                shrinkWrap: true,
                children: [
                  const CustomAppBar(),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.asset('assets/Teeths.png'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Brushing Instructions',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final String brushing =
                                snapshot.data![index]['brushing'] as String;
                            final String image =
                                snapshot.data![index]['image'] as String;

                            return GestureDetector(
                              onTap: () async {
                                String documentId = (await FirebaseFirestore
                                        .instance
                                        .collection('brushingGroups')
                                        .get())
                                    .docs[index]
                                    .id;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Brushing(
                                        documentId: documentId,
                                        brushing: brushing,
                                        image: image),
                                  ),
                                );
                              },
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      brushing,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CountdownPage(),
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/timer.png',
                                width: 100,
                              ),
                              const Text(
                                'Toothbrushing Timer',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
