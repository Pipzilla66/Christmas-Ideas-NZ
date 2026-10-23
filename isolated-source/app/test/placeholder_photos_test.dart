import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/placeholder_photos.dart';
import '../lib/main.dart' show EditorialImage;
void main() {
  test('Different categories and identities choose stable varied images', () {
    final choices=List.generate(20,(i)=>placeholderPhotoFor(kind:'gift',reference:'gift-$i')).toSet();
    expect(choices.length,3);
    expect(placeholderPhotoFor(kind:'gift',reference:'abc'),placeholderPhotoFor(kind:'gift_ideas',reference:'abc'));
    expect(placeholderPhotoFor(kind:'recipe',reference:'abc'),contains('recipes-baking'));
    expect(placeholderPhotoFor(kind:'christmas_tree',reference:'abc'),contains('trees-farm'));
    expect(placeholderPhotoFor(kind:'light_displays',reference:'abc'),contains('lights-'));
    expect(placeholderPhotoFor(kind:'charity',reference:'abc'),contains('charity-gifts'));
    expect(placeholderPhotoPools.values.expand((x)=>x).every((x)=>!x.contains('hero')&&!x.contains('landing')),isTrue);
  });
  test('Recognise our landing artwork without treating ordinary photos as placeholders', () {
    expect(isLandingPhoto('https://christmasideasnz.co.nz/assets/assets/kiwi_christmas_hero_v1.webp?v=3'),isTrue);
    expect(isLandingPhoto('https://example.com/customer-photo.jpg'),isFalse);
    expect(isLandingPhoto('https://example.com/cover_photo.jpg'),isFalse);
  });
  for(final width in [320.0,1100.0]) {
    testWidgets('Missing photos and landing URLs show an inspiration photo at $width',(tester) async {
      tester.view.physicalSize=Size(width,900);tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
      for(final url in [null,'https://christmasideasnz.co.nz/assets/assets/kiwi_christmas_hero_v1.webp']) {
        await tester.pumpWidget(MaterialApp(home:Scaffold(body:Column(children:[EditorialImage(url:url,kind:'gift',reference:'gift-1',width:180,height:160)]))));
        await tester.pumpAndSettle();
        final photo=tester.widget<Image>(find.byType(Image));
        expect((photo.image as AssetImage).assetName,placeholderPhotoFor(kind:'gift',reference:'gift-1'));
        expect(find.text('Inspiration image'),findsOneWidget);
        expect(tester.takeException(),isNull);
      }
    });
  }
  testWidgets('An actual listing photo takes priority over illustration',(tester) async {
    await tester.pumpWidget(const MaterialApp(home:Scaffold(body:SizedBox(width:180,height:160,child:EditorialImage(url:'https://example.com/real-listing.jpg',kind:'gift',reference:'gift-1')))));
    final photos=tester.widgetList<Image>(find.byType(Image));
    expect(photos.any((p)=>p.image is NetworkImage && (p.image as NetworkImage).url=='https://example.com/real-listing.jpg'),isTrue);
    expect(find.text('Inspiration image'),findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
