import 'package:car_pool_driver/pages/add_ride_page.dart';
import 'package:car_pool_driver/services/ride_service.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                const Expanded(
                  child: Text(
                    "My Ride",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddRidePage()));
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Ride")),
              ],
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder(
                  future: RideService.getUserRide(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error in loading ride"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<Map<String, dynamic>> rideList = snapshot.data!;

                    if (rideList.isEmpty) {
                      return const Center(child: Text("No rides found"));
                    } else {
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.blue[300],
                              child: ListTile(
                                isThreeLine: true,
                                title: Text(
                                    "Origin: ${rideList[index]["data"].origin}\nDestination: ${rideList[index]["data"].destination}"),
                                subtitle: Text(
                                    "Ride Date: ${rideList[index]["data"].startDateTime.toIso8601String()}\nFare: RM${rideList[index]["data"].fare}"),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    bool isSuccess =
                                        await RideService.deleteRide(
                                            rideList[index]["id"]);
                                    if (isSuccess) {
                                      Helper.showSnackBar(
                                          context, "Delete ride successfully");
                                      setState(() {});
                                    } else {
                                      Helper.showSnackBar(context,
                                          "Error occurred in deleting ride");
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: rideList.length);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
