import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../diary/utils/pallete.dart';
class MealLogging extends StatefulWidget {
  const MealLogging({super.key});

  @override
  State<MealLogging> createState() => _MealLoggingState();
}

class _MealLoggingState extends State<MealLogging> {
  final currentUser = FirebaseAuth.instance.currentUser;
  static final firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _proteinController = TextEditingController();
  TextEditingController _cabohydrateController = TextEditingController();
  TextEditingController _fatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving=false;
  int calculatecalories(String protein, String cab, String fat){
    int protval = int.tryParse(protein) ?? 0;
    int cabval = int.tryParse(cab) ?? 0;
    int fatval = int.tryParse(fat) ?? 0;
    int calories= (protval*4) + (cabval*4) + (fatval*9);
    return calories;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Logging")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection("allMeals").doc(currentUser?.uid).collection("meals")
          .orderBy("timestamp", descending: false).snapshots(),
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
                  QueryDocumentSnapshot<Object?> journal =
                  snapshot.data!.docs[index];
                  return CustomTile(
                    entryData: journal,
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
                        title: const Text('New Meal'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: SizedBox(
                              width:320,
                              child:  Column(
                                children: <Widget>[
                                   const Text("N/B: 1 gram of carbohydrate = 4 calories, 1 gram of protein = 4 calories, 1 gram of fat = 9 calories",
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.indigo, fontSize: 13, letterSpacing: .3)),

                                  const SizedBox(height: 10,),
                                  TextFormField(

                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Name',
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
                                      controller: _proteinController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Protein Content(grams)',
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
                                      controller: _cabohydrateController,
                                    keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Carbohydrate Content (grams)',
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
                                      controller: _fatController,
                                    keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Fat(grams)',
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
                                      controller: _notesController,
                                      decoration: const InputDecoration(
                                        labelText: 'Notes',
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
    var result =calculatecalories(_proteinController.text,_cabohydrateController.text,_fatController.text);
    debugPrint(result.toString());
    setState(() {
      _isSaving = true;
    });
    final uid= currentUser!.uid;
    await firestore.collection("allMeals").doc(currentUser?.uid).collection("meals")
        .add(
        {
          'uid': uid,
          'name': _nameController.text,
          'calories': result,
          'fat': _fatController.text,
          'protein': _proteinController.text,
          'carbohydrate': _cabohydrateController.text,
          'notes': _notesController.text,
          'timestamp': DateTime.now(),
        });
    setState(() {
      _isSaving = false;

      _cabohydrateController.clear();
      _notesController.clear();
      _fatController.clear();
      _nameController.clear();
      _proteinController.clear();


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
    return Column(
      children: [
        const SizedBox(height: 5),
        ListTile(
          tileColor: Colors.blue.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(entryData['name'],style: const TextStyle(
              color: Colors.deepOrangeAccent, fontSize: 25, letterSpacing: .3)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text("Fat Content: ${entryData['fat']}",style: const TextStyle(
              color: Colors.white, letterSpacing: .3)),
              const SizedBox(height: 5),
              Text("Protein Content: ${entryData['protein'].toString()}",style: const TextStyle(
                  color: Colors.white, letterSpacing: .3)),
              const SizedBox(height: 5),
              Text("Carbohydrate Content: ${entryData['carbohydrate'].toString()}",style: const TextStyle(
                  color: Colors.white, letterSpacing: .3)),
              const SizedBox(height: 5),
              Text(
                  "Notes :${entryData['notes']}",style: const TextStyle(
              color: Colors.white, letterSpacing: .3)
              ),
            ],
          ),


        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

