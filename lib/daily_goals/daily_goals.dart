import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/daily_goals/goalview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/media_service.dart';
class DailyGoals extends StatefulWidget {
  const DailyGoals({super.key});

  @override
  State<DailyGoals> createState() => _DailyGoalsState();
}

class _DailyGoalsState extends State<DailyGoals> {
  final currentUser = FirebaseAuth.instance.currentUser;
  static final firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _caloriesController = TextEditingController();
  TextEditingController _levelController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSaving=false;
  Uint8List? file;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Goals ")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("fitness").doc(currentUser?.uid).collection("goals")
            .orderBy("date", descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?> goals =
                  snapshot.data!.docs[index];
                  return CustomTile(
                    entryData: goals,
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        insetPadding: const EdgeInsets.all(12), // Outside Padding
                        contentPadding: const EdgeInsets.all(12),
                        scrollable: true,
                        title: const Text('New Fitness Goals'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: SizedBox(
                              width:320,
                              child:  Column(
                                children: <Widget>[

                                  GestureDetector(
                                    onTap: () async {
                                      final pickedImage =
                                      await MediaService.pickImage();
                                      setState(() => file = pickedImage!);
                                    },
                                    child: file != null
                                        ? CircleAvatar(
                                      radius: 100,
                                      backgroundImage: MemoryImage(file!),
                                    )
                                        : const CircleAvatar(
                                      radius: 100,
                                      backgroundColor: Colors.brown,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  const SizedBox(height: 10,),
                                  TextFormField(

                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Name/Activity',
                                        icon: Icon(Icons.food_bank),

                                      ),
                                      validator: (val) {
                                        if (val!.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      }
                                  ),
                                  TextFormField(
                                      controller: _caloriesController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Number of Calories (Kcal)',
                                        icon: Icon(Icons.numbers),
                                      ),
                                      validator: (val) {
                                        if (val!.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      }
                                  ),
                                  TextFormField(
                                      controller: _levelController,
                                      decoration: const InputDecoration(
                                        labelText: 'Level (Medium | Easy | Hard)',
                                        icon: Icon(Icons.numbers),
                                      ),
                                      validator: (val) {
                                        if (val!.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      }
                                  ),
                                  TextFormField(
                                      controller: _timeController,
                                      decoration: const InputDecoration(
                                        labelText: 'Time Frame or Period (Minutes | Hours)',
                                        icon: Icon(Icons.numbers_sharp),
                                      ),
                                      validator: (val) {
                                        if (val!.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      }
                                  ),
                                  TextFormField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        labelText: 'Description',
                                        icon: Icon(Icons.info),
                                      ),
                                      validator: (val) {
                                        if (val!.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      }
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: [

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  style:  ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    setState(() {
                                      _isSaving = false;
                                    });
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                const SizedBox(width: 180,),
                                ElevatedButton(
                                    child: _isSaving ? const Text("saving..") : const Text("Submit"),
                                    onPressed: () {
                                      if(_formKey.currentState!.validate()){
                                        setState(() {
                                          _isSaving = true;
                                        });
                                        _handleSave();

                                      }
                                    }),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                );
              });

        },
        child: const Icon(Icons.add),

      ),
    );
  }

  Future  _handleSave() async {

    setState(() {
      _isSaving = true;
    });
    final uid= currentUser!.uid;
    final image =
    await MediaService.uploadImage(
        file!, 'image/goals/$uid');
    await firestore.collection("fitness").doc(currentUser?.uid).collection("goals")
        .add(
        {
          'uid': uid,
          'name': _nameController.text,
          'image': image,
          'calories': _caloriesController.text,
          'time': _timeController.text,
          'level': _levelController.text,
          'description': _descriptionController.text,
          'date': DateTime.now(),
        });
    setState(() {
      _isSaving = false;

      _levelController.clear();
      _descriptionController.clear();
      _timeController.clear();
      _nameController.clear();
      _caloriesController.clear();


    });
    Navigator.of(context).pop(false);

  }
}

class CustomTile extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> entryData;
  const CustomTile(
      {super.key,
        required this.entryData});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: media.width * 0.20,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 3, color: Colors.white),
                    image:  DecorationImage(
                        image: NetworkImage( entryData["image"]),
                        fit: BoxFit.fill),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        entryData["name"],
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        entryData["calories"]+" Calories Burn" +" | " +entryData["time"],
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                      GoalView(
                                       calories: entryData["calories"],
                                        date: entryData["date"].toString(),
                                        description: entryData["description"],
                                        name: entryData["name"],
                                        level: entryData["level"],
                                        time:   entryData["time"],
                                        image:   entryData["image"],
                                     )));
                          },
                          icon: const Icon(
                            Icons.navigate_next,
                            color:Colors.brown,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}