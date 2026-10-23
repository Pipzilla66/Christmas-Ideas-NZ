// ignore: deprecated_member_use
import 'dart:html' as html;

void downloadText(String text, String name, String mime) {
  final blob = html.Blob([text], mime);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final link = html.AnchorElement(href: url)..download = name;
  html.document.body?.append(link);
  link.click();
  link.remove();
  Future.delayed(
    const Duration(seconds: 1),
    () => html.Url.revokeObjectUrl(url),
  );
}
