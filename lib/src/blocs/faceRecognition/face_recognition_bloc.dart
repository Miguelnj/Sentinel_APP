import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterappfdp/src/blocs/faceRecognition/face_recognition_events.dart';
import 'package:flutterappfdp/src/blocs/faceRecognition/face_recognition_states.dart';
import 'package:flutterappfdp/src/services/event_repository.dart';
import 'package:flutterappfdp/src/services/upload_s3.dart';

class FaceRecognitionBloc extends Bloc<FaceRecognitionEvent, FaceRecognitionState>{
  EventRepository _eventRepository = EventRepository();


  @override
  FaceRecognitionState get initialState => InitState();

  @override
  void onTransition(
      Transition<FaceRecognitionEvent, FaceRecognitionState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<FaceRecognitionState> mapEventToState(FaceRecognitionEvent event) async* {
    if(event is SubmitVideoEvent){
      String videoId = event.eventId + ".";
      print(videoId);
      final int statusCode = await uploadVideoFile(event.video, videoId);
      print("Response status for upload video: $statusCode");
      if(statusCode == 200 || statusCode == 201 || statusCode == 204){
        final int statusCodeVideoProcessing = await _eventRepository.triggerProcessVideoFaceRecognition(videoId);
        print("Response status for trigger video processing: $statusCodeVideoProcessing");
        if(statusCodeVideoProcessing == 200) yield SuccessVideoUploaded();
        else yield FailedVideoUpload();
      } else yield FailedVideoUpload();
    }
  }
}