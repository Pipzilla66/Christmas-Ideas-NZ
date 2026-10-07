import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/listing_filters.dart';
import 'package:christmas_ideas_nz_test/seasonal_listings.dart';

void main() {
  test('Charities and real trees have separate categories from stores', () {
    final all = [
      <String,dynamic>{'_type':'Store','business_type':'charity','name':'National charity','region':'Nationwide'},
      <String,dynamic>{'_type':'Store','business_type':'christmas_tree','name':'Tree farm','region':'Canterbury','city':'Christchurch'},
      <String,dynamic>{'_type':'Store','business_type':'store','name':'Christmas shop','region':'Canterbury','city':'Christchurch'},
    ];
    final now = DateTime(2026,12,1);
    expect(filterListings(all,now:now,category:'Christmas Shops').map((e)=>e['name']),['Christmas shop']);
    expect(filterListings(all,now:now,category:'Real Christmas Trees').map((e)=>e['name']),['Tree farm']);
    expect(filterListings(all,now:now,category:'Christmas Charities',region:'Canterbury',city:'Christchurch').map((e)=>e['name']),['National charity']);
    expect(filterListings(all,now:now,category:'Real Christmas Trees',region:'Auckland'),isEmpty);
  });
  testWidgets('Published charity requires name and valid official URL', (tester) async {
    tester.view.physicalSize = const Size(1000, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home:SeasonalListingEditor(type:'charity',item:{'status':'published','region':'Nationwide'})));
    await tester.tap(find.text('Save listing'));
    await tester.pump();
    expect(find.text('Enter a name'),findsOneWidget);
    expect(find.text('Add a website before publishing'),findsOneWidget);
  });
}
