// ignore_for_file: deprecated_member_use
import 'dart:html' as html;
void downloadCsv(String text,String name){final blob=html.Blob([text],'text/csv;charset=utf-8');final url=html.Url.createObjectUrlFromBlob(blob);final link=html.AnchorElement(href:url)..download=name;html.document.body?.append(link);link.click();link.remove();Future.delayed(const Duration(seconds:1),()=>html.Url.revokeObjectUrl(url));}
