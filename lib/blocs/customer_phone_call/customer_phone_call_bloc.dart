import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:document_analyser_poc_new/models/call_summary.dart';
import 'package:document_analyser_poc_new/models/error_details.dart';
import 'package:document_analyser_poc_new/services/phone_call_service.dart';
import 'package:equatable/equatable.dart';

part 'customer_phone_call_event.dart';
part 'customer_phone_call_state.dart';

class CustomerPhoneCallBloc
    extends Bloc<CustomerPhoneCallEvent, CustomerPhoneCallState> {
  late PhoneCallService _phoneCallService;

  CustomerPhoneCallBloc(PhoneCallService phoneCallService)
      : super(CustomerPhoneCallBlocInitial()) {
    _phoneCallService = phoneCallService;
    on<RequestRecordPermissions>(_requestRecordPermissionsHandler);
    on<StartCallEvent>(_startCallEventHandler);
    on<GetCallSummary>(_getCallSummaryEvent);
  }

  Future<void> _getCallSummaryEvent(
    GetCallSummary event,
    Emitter<CustomerPhoneCallState> emit,
  ) async {
    try {
      // Emit LoadingState at the start to show loading indicator
      emit(const LoadingState(isLoading: true));

      // Await the API response
      Either<ErrorDetails, CallSummary> response =
          await _phoneCallService.getCallSummary();

      // Handle the response
      response.fold(
        (error) => emit(ErrorState(error: error)), // Emit ErrorState on failure
        (data) {
          emit(CallSummaryState(
              callSummary:
                  data.callSummary)); // Emit CallSummaryState on success
        },
      );
    } catch (e) {
      // Emit ErrorState in case of an exception
      emit(ErrorState(error: ErrorDetails(errorMessage: e.toString())));
    }
  }

  FutureOr<void> _requestRecordPermissionsHandler(
    RequestRecordPermissions event,
    Emitter<CustomerPhoneCallState> emit,
  ) {
    // _phoneCallService.requestPermissions();
  }

  Future<void> _startCallEventHandler(
    StartCallEvent event,
    Emitter<CustomerPhoneCallState> emit,
  ) async {
    String phoneNumber = event.phoneNumber;
    print("phone number");
    print(phoneNumber);
    await _phoneCallService.makeCall(phoneNumber).then((value) {
      emit(const CallState(isCallStarted: true));
    });
  }
}
