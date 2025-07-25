import '../models/first_aid_model.dart';

class FirstAidController {
  List<FirstAidItem> getFirstAidItems() {
    return [
      FirstAidItem(
        title: "CPR (Cardiopulmonary Resuscitation)",
        precautions: "1. Check responsiveness.\n2. Call 1122.\n3. 30 chest compressions + 2 rescue breaths.",
      ),
      FirstAidItem(
        title: "Choking",
        precautions: "1. Ask if choking.\n2. Perform Heimlich maneuver.\n3. For infants: 5 back blows + 5 chest thrusts.",
      ),
      FirstAidItem(
        title: "Bleeding",
        precautions: "1. Apply pressure.\n2. Elevate limb.\n3. Do not remove embedded object.",
      ),
      FirstAidItem(
        title: "Burns",
        precautions: "1. Cool with water (10+ minutes).\n2. No ice or creams.\n3. Cover with gauze.",
      ),
      FirstAidItem(
        title: "Fractures",
        precautions: "1. Immobilize.\n2. Apply cold packs.\n3. Do not move broken bones.",
      ),
      FirstAidItem(
        title: "NoseBleed",
        precautions: "1. Sit upright and lean forward.\n2. Pinch the nose just above the nostrils for 10 minutes.\n3. Don’t lie down or tilt head backward.",
      ),
      FirstAidItem(
        title: "Heart Attack",
        precautions: "1. Call emergency services immediately.\n2. Loosen tight clothing.\n3. If conscious, give aspirin (unless allergic).",
      ),
      FirstAidItem(
        title: "Fainting",
        precautions: "1. Lay the person flat and elevate legs.\n2. Loosen tight clothing.\n3. Do not give anything to eat or drink until fully alert.",
      ),
      FirstAidItem(
        title: "Electric Shock",
        precautions: "1. Turn off power source before touching the person.\n2. Do not touch with bare hands if power is still on.\n3. Call for help and monitor breathing.",
      ),
      FirstAidItem(
        title: "Snake Bite",
        precautions: "1. Immobilize the limb.\n2. Don’t cut or suck the wound.\n3. Seek antivenom at a hospital urgently.",
      ),
      // Add more situations as needed...
    ];
  }
}
