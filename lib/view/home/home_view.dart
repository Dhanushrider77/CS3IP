import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/common/color_extension.dart';
import 'package:fit/common_widget/round_button.dart';
import 'package:fit/daily_goals/daily_goals.dart';
import 'package:fit/view/diary/diary_screen.dart';
import 'package:fit/view/exercise/exercise_view.dart';
import 'package:fit/view/exercise/jumping_jack_view.dart';
import 'package:fit/view/exercise/planks.dart';
import 'package:fit/view/exercise/squats.dart';
import 'package:fit/view/meals/meals.dart';
import 'package:fit/view/weather/weather_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String bmii = "Loading...";
  var cal = 200.1;
  var bm = 10.0; // Initial text while loading data
  List<_ChartData> chartData = <_ChartData>[];
  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    fetchData();
    getDataFromFireStore();
  }
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return ' Afternoon';
    }
    return ' Evening';
  }
  Future<void> fetchData() async {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser?.uid;
      var db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(user);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        var calorie = data['calories'].toString();
        if (!mounted) return;
        setState(() {
          bm = double.parse(data['bmi']);

          if (cal == null) {
            return;
          } else {
            cal = double.parse(calorie);
          }
        });
        if (bm < 18.5) {
          if (!mounted) return;
          setState(() {
            bmii = "Underweight.";
          });
        } else if (bm > 18.5 && bm < 24.9) {
          if (!mounted) return;
          setState(() {
            bmii = 'Healthy Weight.';
          });
        } else if (bm > 25.0 && bm < 39.9) {
          if (!mounted) return;
          setState(() {
            bmii = "Overweight.";
          });
        } else if (bm > 30) {
          if (!mounted) return;
          setState(() {
            bmii = "Obesity.";
          });
        }
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );

    // Data exists, you can access it using snapshot.data()
  }
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    var lastPosition = await Geolocator.getLastKnownPosition();
  }

Future<void> getDataFromFireStore() async {
  var snapShotsValue =
  await FirebaseFirestore.instance.collection("allMeals").doc(currentUser?.uid).collection("meals").get();
  debugPrint(snapShotsValue.docs.toString());
  List<_ChartData> list = snapShotsValue.docs
      .map((e) => _ChartData(
      x: e.data()['timestamp'].toDate().toString(),
      // x: DateTime.fromMillisecondsSinceEpoch(
      //     e.data()['x'].millisecondsSinceEpoch),
      y: e.data()['calories']))
      .toList();
  setState(() {
    chartData = list;
  });
}
  @override
  Widget build(BuildContext context) {
    fetchData();
    var media = MediaQuery.of(context).size;
    var auth = FirebaseAuth.instance;
    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child:const Text('No'),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              //return true when click on "Yes"
              child:const Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "Good,${greeting()}",
                          style: const TextStyle(
                              color: Colors.white, fontFamily: "Poppins"),
                        ),
                        Text(
                          "${auth.currentUser?.displayName}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "images/notification_active.png",
                          height: 25,
                          width: 25,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: media.width * 0.35,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          "images/banner.jpg",
                          height: media.width * 0.35,
                          width: double.maxFinite,
                          fit: BoxFit.fitWidth,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "BMI (Body Mass Index)",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Status : $bmii",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 130,
                                    child: RoundButton(
                                        title: "Today's Weather",
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WeatherPage()));
                                        }),
                                  ),
                                ],
                              ),
                              AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {},
                                      ),
                                      startDegreeOffset: 270,
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 1,
                                      centerSpaceRadius: 0,
                                      sections: showingSections()),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: media.width * 0.12,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: TColor.primaryColor1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Today's Diary",
                          style: TextStyle(
                              color: TColor.white,
                              fontFamily: "Poppins",
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                          height: 40,
                          width: 100,
                          child: RoundButton(
                              title: "Diary",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const DiaryHome()));
                              })),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: media.width * 0.12,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: TColor.primaryColor1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Today's Target",
                          style: TextStyle(
                              color: TColor.white,
                              fontFamily: "Poppins",
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                          height: 40,
                          width: 100,
                          child: RoundButton(
                              title: "Check",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ExerciseView()));
                              })),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: media.width * 0.12,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: TColor.primaryColor1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Today's Goals",
                          style: TextStyle(
                              color: TColor.white,
                              fontFamily: "Poppins",
                              fontSize: 15),
                        ),
                      ),
                      SizedBox(
                          height: 40,
                          width: 100,
                          child: RoundButton(
                              title: "Set Goals",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const DailyGoals()));
                              })),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(

                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: TColor.primaryColor1.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            const Text(
                              "Calories",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              "$cal kcal",
                              style: TextStyle(
                                  color: TColor.primaryColor1,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MealLogging()));
                                },
                                child: const Text("Meal Logging"))

                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: media.width * 0.15,
                          width: media.width * 0.15,
                          child: SimpleCircularProgressBar(
                            valueNotifier: ValueNotifier(cal),
                            maxValue: 1000.0,
                            backStrokeWidth: 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Meal Logging and Calorie Analysis",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Poppins"),
                      ),

                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: media.width * 0.40,
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

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:
                              SfCartesianChart(
                                  title: ChartTitle(text: 'Daily Calories analysis'),
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  primaryXAxis:  CategoryAxis(
                                      title: AxisTitle(
                                          text: 'Date and Time',
                                          textStyle: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontFamily: 'Roboto',
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w300
                                          )),
                                  ),
                                  series: <LineSeries<_ChartData, String>>[
                                    LineSeries<_ChartData, String>(
                                        dataSource: chartData,
                                        xValueMapper: (_ChartData data, _) => data.x,
                                        yAxisName: "Date and Time",
                                        yValueMapper: (_ChartData data, _) => data.y,
                                         name: 'Calories',),

                                  ]),
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Workout",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Poppins"),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ExerciseView()));
                          },
                          icon: const Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          label: const Text("See more"))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
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
                            Image.asset("images/full_body_icon.png"),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Jumping Jack",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "180 Calories Burn | 20 minutes",
                                    style: TextStyle(
                                        color: TColor.darkgray,
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
                                                    const JumpingJackView()));
                                      },
                                      icon: Icon(
                                        Icons.navigate_next,
                                        color: TColor.secondaryColor1,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
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
                            Image.asset("images/lowerbody_icon.png"),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Squats",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "200 Calories Burn | 30 minutes",
                                    style: TextStyle(
                                        color: TColor.darkgray,
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
                                                    const SquatsView()));
                                      },
                                      icon: Icon(
                                        Icons.navigate_next,
                                        color: TColor.secondaryColor1,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
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
                            Image.asset("images/ab_logo.png"),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Planks",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "180 Calories Burn | 20 minutes",
                                    style: TextStyle(
                                        color: TColor.darkgray,
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
                                                    const PlanksView()));
                                      },
                                      icon: Icon(
                                        Icons.navigate_next,
                                        color: TColor.secondaryColor1,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    ),
    ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        var color0 = TColor.secondaryColor1;
        var color1 = TColor.white;
        var vl = 100 - bm;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: bm,
                title: '',
                radius: 65,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: Text(
                  bm.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ));
          case 1:
            return PieChartSectionData(
              color: color1,
              value: vl.toDouble(),
              title: '',
              radius: 50,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }

}
class _ChartData {
  _ChartData({this.x, this.y});
  final String? x;
  final int? y;
}
