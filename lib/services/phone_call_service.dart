import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:document_analyser_poc_new/models/call_summary.dart';
import 'package:document_analyser_poc_new/models/error_details.dart';
import 'package:document_analyser_poc_new/models/ranked_policy.dart';
import 'package:document_analyser_poc_new/utils/app_network_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneCallService {
  // Future<void> requestPermissions() async {
  //   await Permission.microphone.request();
  //   if (!kIsWeb) {
  //     await Permission.storage.request();
  //     await Permission.phone.request();
  //   }
  // }

  Future<void> startRecording() async {}

  Future<void> stopRecording() async {}

  Future<void> makeCall(String number) async {
    if (!kIsWeb) bool? _ = await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<Either<ErrorDetails, CallSummary>> getCallSummary() async {
    try {
      Response response = await Dio().post(
        "${AppNetworkConstants.BASE_URL}/phone-call/summary",
        data: {
          "file_url": "assets/audio_files/policy_conv_2.mp3",
        },
      );

      // Handle success
      if (response.statusCode == 200) {
        // Assuming the response contains the call summary details in JSON
        CallSummary callSummary = CallSummary.fromJson(response.data);
        return Right(callSummary); // Return the CallSummary wrapped in Right
      } else {
        // Handle non-200 status codes as errors
        return Left(ErrorDetails(
          errorMessage: "Failed to get call summary",
          statusCode: response.statusCode!,
        ));
      }
    } on DioException catch (e) {
      // Handle DioError separately to extract relevant error details
      if (e.response != null) {
        return Left(ErrorDetails(
          errorMessage: e.response?.data['message'] ?? 'Unknown error occurred',
          statusCode: e.response!.statusCode!,
        ));
      } else {
        return Left(ErrorDetails(
          errorMessage: e.message!,
        ));
      }
    } catch (e) {
      // Handle other types of errors
      return Left(ErrorDetails(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<Either<ErrorDetails, List<RankedPolicy>>> getRankedPolicies(
    String summary,
  ) async {
    try {
      print('summary');
      print(summary);
      Response response = await Dio().post(
        "${AppNetworkConstants.BASE_URL}/phone-call/generate_policies",
        data: {
          "summary": summary,
        },
      );

      // Handle success
      if (response.statusCode == 200) {
        // Assuming the response contains the call summary details in JSON
        List<RankedPolicy> rankedPolicies =
            ((response.data)["ranked_policies"] as List).map((policy) {
          return RankedPolicy.fromJson(policy);
        }).toList();
        return Right(rankedPolicies);
      } else {
        // Handle non-200 status codes as errors
        return Left(ErrorDetails(
          errorMessage: "Failed to get call summary",
          statusCode: response.statusCode!,
        ));
      }
    } on DioException catch (e) {
      // Handle DioError separately to extract relevant error details
      if (e.response != null) {
        return Left(ErrorDetails(
          errorMessage: e.response?.data['message'] ?? 'Unknown error occurred',
          statusCode: e.response!.statusCode!,
        ));
      } else {
        return Left(ErrorDetails(
          errorMessage: e.message!,
        ));
      }
    } catch (e) {
      // Handle other types of errors
      return Left(ErrorDetails(
        errorMessage: e.toString(),
      ));
    }
  }
}
