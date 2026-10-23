import 'package:flutter/material.dart';

/// Null means cancel; an empty string means reject without feedback.
Future<String?> requestRejectionFeedback(BuildContext context, String title) =>
    showDialog<String>(
      context: context,
      builder: (_) => RejectionFeedbackDialog(title: title),
    );

class RejectionFeedbackDialog extends StatefulWidget {
  final String title;
  const RejectionFeedbackDialog({super.key, required this.title});

  @override
  State<RejectionFeedbackDialog> createState() =>
      _RejectionFeedbackDialogState();
}

class _RejectionFeedbackDialogState extends State<RejectionFeedbackDialog> {
  final feedback = TextEditingController();

  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Reject submission'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const SizedBox(height: 12),
          const Text(
            'You can explain why this submission will not be published. Feedback appears in the submitter’s Me → Notifications.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: feedback,
            minLines: 3,
            maxLines: 5,
            maxLength: 1000,
            decoration: const InputDecoration(
              labelText: 'Feedback (optional)',
              hintText:
                  'For example, please include the event date and location.',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, feedback.text.trim()),
        child: const Text('Reject submission'),
      ),
    ],
  );
}
