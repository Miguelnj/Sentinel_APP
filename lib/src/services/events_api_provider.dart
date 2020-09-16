import 'dart:async';
import 'package:flutterappfdp/src/models/eventModel.dart';
import 'package:flutterappfdp/src/services/user_repository.dart';
import 'package:http/http.dart';
import 'dart:convert';


class EventApiProvider {

  String apiURL = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
  String ebApiURL = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

  Future<List<Event>> fetchEventList() async {
    String jwt = await UserRepository.getToken();
    final response = await get(apiURL + "events",
        headers: {'Content-Type': 'application/json;charset=utf-8', 'Authorization': jwt});
    if (response.statusCode == 200)
      return EventModel.eventListFromJson(json.decode(utf8.decode(response.bodyBytes))).events;
    else if (response.statusCode == 404) return null;
    else throw Exception('Failed to get Data\n' + json.decode(utf8.decode(response.bodyBytes)).toString());
  }

  Future<Event> fetchEventGivenId(String id) async {
    String jwt = await UserRepository.getToken();
    final response = await get(apiURL + "events/" + id, headers: {'Authorization': jwt});
    if (response.statusCode == 200)
      return EventModel.eventFromJson(json.decode(utf8.decode(response.bodyBytes))).event;
    else
      throw Exception('Failed to get Data\n' + json.decode(utf8.decode(response.bodyBytes)).toString());
  }

  Future<int> updateAttendeesOfEvent(String id, Map<String, dynamic> attendees) async {
    String jwt = await UserRepository.getToken();
    String jsonAttendees = json.encode({"attendees": attendees});
    final response = await put(apiURL + "events/attendees/" + id,
        headers: {'Content-Type': 'application/json', 'Authorization': jwt}, body: jsonAttendees);
    return response.statusCode;
  }

  Future<int> deleteAttendeeOfEvent(String eventId, String userId) async{
    String jwt = await UserRepository.getToken();
    final response = await delete(apiURL + "events/attendees/" + eventId + "/" + userId,
        headers: {'Content-Type': 'application/json', 'Authorization': jwt});
    return response.statusCode;
  }

  Future<Map> getQRCheckRegistry(String eventId) async{
    String jwt = await UserRepository.getToken();
    String jsonEventId = json.encode({"event_id": eventId});
    final response = await post(apiURL + "qr", headers: {'Content-Type': 'application/json', 'Authorization': jwt},
        body: jsonEventId);
    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<int> scannedQRCodeSubmit(String uuid, int timestamp) async{
    String jwt = await UserRepository.getToken();
    String jsonData = json.encode({"uuid": uuid, "timestamp": timestamp});
    final response = await post(apiURL + "qr/scanned", headers: {'Content-Type': 'application/json', 'Authorization': jwt},
        body: jsonData);
    return response.statusCode;
  }

  Future<int> postCreateEvent(String name, String location, DateTime startDate, DateTime endDate) async{
    String jwt = await UserRepository.getToken();
    String jsonData = json.encode({"name": name, "location": location,
      "date": {"from": startDate.toIso8601String(), "to": endDate.toIso8601String()}});
    final response = await post(apiURL + "events", headers: {'Content-Type': 'application/json', 'Authorization': jwt},
        body: jsonData);
    return response.statusCode;
  }

  Future<int> sendRequestToTriggerFaceRecognitionVideoProcessing(String videoId) async{
    final response = await get(ebApiURL + "?file=" + videoId);
    return response.statusCode;
  }

  Future<int> sendEventSumUpRequest(String eventId) async{
    String jwt = await UserRepository.getToken();
    final response = await post(apiURL + "events/email?event=" + eventId, headers: {'Authorization': jwt});
    return response.statusCode;
  }

  Future<int> deleteEvent(String eventId) async{
    String jwt = await UserRepository.getToken();
    final response = await delete(apiURL + "events/" + eventId, headers: {'Content-Type': 'application/json', 'Authorization': jwt});
    return response.statusCode;
  }

}
