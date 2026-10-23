export 'csv_export_stub.dart' if (dart.library.html) 'csv_export_web.dart';
String csvCell(dynamic value) {
  var text=(value??'').toString();
  // Prevent spreadsheet formula execution from user-entered account names.
  if(RegExp(r'^\s*[=+@-]').hasMatch(text)||text.startsWith('\t')||text.startsWith('\r'))text="'"+text;
  return '"${text.replaceAll('"','""')}"';
}
String accountCsv(List<Map<String,dynamic>> rows,{bool entriesOnly=false}) {
  final result=<String>['Entry number,Name,Email,Sign-up date (UTC),Role,Exclusion'];
  for(final row in rows){if(entriesOnly&&row['entry_number']==null)continue;result.add([row['entry_number'],row['name'],row['email'],row['created_at'],row['role'],row['exclusion']].map(csvCell).join(','));}
  return '\uFEFF${result.join('\r\n')}\r\n';
}
