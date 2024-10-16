import 'package:document_analyser_poc_new/models/leads.dart';
import 'package:document_analyser_poc_new/screens/call_customers/call_customer_screen.dart';
import 'package:document_analyser_poc_new/screens/call_screen.dart';
import 'package:document_analyser_poc_new/screens/navBar/customers/customers_screen.dart';
import 'package:document_analyser_poc_new/screens/navBar/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> navbarRoutes = [
  GoRoute(
    path: "/dashboard",
    name: "dashboard",
    builder: (context, state) {
      return const DashboardPage();
    },
  ),
  GoRoute(
    path: "/customers",
    name: "customers",
    builder: (context, state) {
      return const CustomersPage();
    },
  ),
  GoRoute(
    name: "call_customers",
    path: "/customers/:id/call",
    pageBuilder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      print('extraData $extraData');

      final lead = extraData?['lead'] as Leads;
      print('lead $lead');

      final callerId = extraData?['callerId'];
      print('callerId $callerId');

      return MaterialPage(
          child: CallCustomerPage(
        lead: lead,
        callerId: callerId,
      ));
    },
  ),
  GoRoute(
    name: "in_call",
    path: "/incall/:callerId/:calleeId",
    builder: (context, state) {
      final callerId = state.pathParameters["callerId"]!;
      final calleeId = state.pathParameters["calleeId"]!;
      final offer = state.extra;

      return CallScreen(
        callerId: callerId,
        calleeId: calleeId,
        offer: offer,
      );
    },
  )
];
