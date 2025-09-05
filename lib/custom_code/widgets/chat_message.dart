import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isSentByMe,
    this.senderName,
    this.imagePath,
  });

  final String message;
  final String timestamp;
  final bool isSentByMe;
  final String? senderName;
  final String? imagePath;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        margin: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.isSentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!widget.isSentByMe && widget.senderName != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
                child: Text(
                  widget.senderName!,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).labelMediumFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).labelMediumFamily),
                      ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: widget.isSentByMe
                    ? FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1)
                    : FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4.0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.imagePath != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            widget.imagePath!,
                            width: 200.0,
                            height: 150.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Text(
                      widget.message,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: widget.isSentByMe
                                ? Colors.white
                                : FlutterFlowTheme.of(context).primaryText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
              child: Text(
                widget.timestamp,
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 10.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).labelSmallFamily),
                    ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(
            begin: widget.isSentByMe ? 0.1 : -0.1,
            end: 0,
            duration: 300.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }
}
