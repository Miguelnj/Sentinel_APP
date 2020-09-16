import 'dart:async';

import 'package:flutterappfdp/src/models/eventModel.dart';
import 'package:flutterappfdp/src/services/events_api_provider.dart';

class EventRepository {
  final eventsApiProvider = EventApiProvider();

  Future<List<Event>> fetchAllEvents() => eventsApiProvider.fetchEventList();

  Future<Event> fetchEventById(String id) => eventsApiProvider.fetchEventGivenId(id);

  Future<int> updateAttendeesOfEvent(String id, Map<String, dynamic> attendees) =>
      eventsApiProvider.updateAttendeesOfEvent(id, attendees);

  Future<int> deleteAttendeeOfEvent(String eventId, String userId) =>
      eventsApiProvider.deleteAttendeeOfEvent(eventId, userId);

  Future<Map> getQRCheckRegistry(String eventId) => eventsApiProvider.getQRCheckRegistry(eventId);

  Future<int> scannedQRCodeSubmit(String uuid, int timestamp) => eventsApiProvider.scannedQRCodeSubmit(uuid, timestamp);

  Future<int> createEvent(String name, String location, DateTime startDate, DateTime endDate) =>
    eventsApiProvider.postCreateEvent(name, location, startDate, endDate);

  Future<int> triggerProcessVideoFaceRecognition(String videoId) => eventsApiProvider.sendRequestToTriggerFaceRecognitionVideoProcessing(videoId);

  Future<int> sendEventSumUpRequest(String eventId) => eventsApiProvider.sendEventSumUpRequest(eventId);

  Future<int> deleteEvent(String eventId) => eventsApiProvider.deleteEvent(eventId);

}