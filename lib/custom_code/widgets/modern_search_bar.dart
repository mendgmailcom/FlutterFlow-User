import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernSearchBar extends StatefulWidget {
  const ModernSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search for services...',
    this.controller,
    this.focusNode,
  });

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar> {
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    // Listen to focus changes
    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Remove listener
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() => _hasFocus = widget.focusNode?.hasFocus ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: () {
          setState(() => _hasFocus = true);
        },
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 0.0),
            child: Icon(
              Icons.search,
              color: _hasFocus
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
          ),
          suffixIcon:
              widget.controller != null && widget.controller!.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.controller?.clear();
                          if (widget.onChanged != null) {
                            widget.onChanged!('');
                          }
                        },
                        child: Icon(
                          Icons.close,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 20.0,
                        ),
                      ),
                    )
                  : null,
          hintText: widget.hintText,
          hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14.0,
                letterSpacing: 0.0,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              useGoogleFonts: GoogleFonts.asMap()
                  .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
            ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
