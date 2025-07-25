import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMaps() async {
  final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=hospitals+near+me");

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open Google Maps';
  }
}