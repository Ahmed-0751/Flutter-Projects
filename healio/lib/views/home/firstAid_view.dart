import 'package:flutter/material.dart';
import '../../controllers/first_aid_controller.dart';
import '../../models/first_aid_model.dart';

class FirstAidView extends StatelessWidget {
  const FirstAidView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirstAidController controller = FirstAidController();
    final List<FirstAidItem> items = controller.getFirstAidItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text("First Aid Guide"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(item.precautions),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
