import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class BookingActions {
  static Future<DateTime?> selectDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FlutterFlowTheme.of(context).primary,
              onPrimary: Colors.white,
              surface: FlutterFlowTheme.of(context).secondaryBackground,
              onSurface: FlutterFlowTheme.of(context).primaryText,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<TimeOfDay?> selectTime(BuildContext context) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FlutterFlowTheme.of(context).primary,
              onPrimary: Colors.white,
              surface: FlutterFlowTheme.of(context).secondaryBackground,
              onSurface: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<String?> selectServiceType(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Service Type',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: Text(
                    'Basic Service',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  subtitle: Text(
                    'Standard cleaning service',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop('Basic Service'),
                ),
                ListTile(
                  title: Text(
                    'Premium Service',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  subtitle: Text(
                    'Deep cleaning with premium products',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop('Premium Service'),
                ),
                ListTile(
                  title: Text(
                    'Deluxe Service',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  subtitle: Text(
                    'Complete home cleaning with extras',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop('Deluxe Service'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
