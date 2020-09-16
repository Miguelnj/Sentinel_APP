import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'policy.dart';

Future<int> uploadFile(File file, String username) async {
  const _accessKeyId = 'XXXXXXXXXXXXXX';
  const _secretKeyId = 'XXXXXXXXXXXXXX';
  const _region = 'eu-central-1';
  const _s3Endpoint = 'https://assistance-check-index-faces.s3.eu-central-1.amazonaws.com';

  final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
  final length = await file.length();

  final uri = Uri.parse(_s3Endpoint);
  final req = http.MultipartRequest("POST", uri);
  final multipartFile = http.MultipartFile('file', stream, length, filename: path.basename(file.path));
  final policy = Policy.fromS3PresignedPost(username, 'assistance-check-index-faces', _accessKeyId, 15, length, region: _region);
  final key = SigV4.calculateSigningKey(_secretKeyId, policy.datetime, _region, 's3');
  final signature = SigV4.calculateSignature(key, policy.encode());

  req.files.add(multipartFile);
  req.fields['key'] = policy.key;
  req.fields['acl'] = 'public-read';
  req.fields['X-Amz-Credential'] = policy.credential;
  req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
  req.fields['X-Amz-Date'] = policy.datetime;
  req.fields['Policy'] = policy.encode();
  req.fields['X-Amz-Signature'] = signature;

  try {
    final res = await req.send();
    await for (var value in res.stream) {
      print(value);
    }
    return res.statusCode;
  } catch (e) {
    print(e.toString());
  }
  return 0;
}

Future<int> uploadVideoFile(File file, String filename) async{
  const _accessKeyId = 'XXXXXXXXXXXXXX';
  const _secretKeyId = 'XXXXXXXXXXXXXX';
  const _region = 'eu-central-1';
  const _s3Endpoint = 'https://assistance-check-videos.s3.eu-central-1.amazonaws.com';

  final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
  final length = await file.length();

  final uri = Uri.parse(_s3Endpoint);
  final req = http.MultipartRequest("POST", uri);
  final multipartFile = http.MultipartFile('file', stream, length, filename: path.basename(file.path));
  final policy = Policy.fromS3PresignedPost(filename, 'assistance-check-videos', _accessKeyId, 15, length, region: _region);
  final key = SigV4.calculateSigningKey(_secretKeyId, policy.datetime, _region, 's3');
  final signature = SigV4.calculateSignature(key, policy.encode());

  req.files.add(multipartFile);
  req.fields['key'] = policy.key;
  req.fields['acl'] = 'public-read';
  req.fields['X-Amz-Credential'] = policy.credential;
  req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
  req.fields['X-Amz-Date'] = policy.datetime;
  req.fields['Policy'] = policy.encode();
  req.fields['X-Amz-Signature'] = signature;

  try {
    final res = await req.send();
    await for (var value in res.stream) {
      print(value);
      print("\n");
    }
    return res.statusCode;
  } catch (e) {
    print(e.toString());
  }
  return 0;
}
