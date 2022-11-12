import 'package:shoppingcartfirst/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

List<Item> products = [
  Item(
      productId: '101', category: 'electronic', name: 'Apple iPad 5th Gen. 32GB, '
      'Wi-Fi, 9.7" Tablet, iOS 15 - Space Gray', unit: 'number', price: 599,
      image: 'assets/images/set2/s-l500.png',
      images: [
        'assets/images/set2/s-l500.png',
        'assets/images/set2/s-l500_002.jpg',
        'assets/images/set2/s-l500_003.jpg',
        'assets/images/set2/s-l500_004.jpg',
        'assets/images/set2/s-l500_005.jpg',
        'assets/images/set2/s-l500_006.jpg',
        'assets/images/set2/s-l500_007.jpg',
        'assets/images/set2/s-l500_008.jpg',
        'assets/images/set2/s-l500_009.jpg',
        'assets/images/set2/s-l500_010.jpg',
        'assets/images/set2/s-l500_011.jpg',
        'assets/images/set2/s-l500_012.jpg',
      ]),
  Item(
      productId: '001', category: 'fruits', name: 'Apple', unit: 'Kg', price: 20, image: 'assets/images/apple.png', images: []),
  Item(
      productId: '002',
      category: 'fruits',
      name: 'Mango',
      unit: 'Doz',
      price: 30,
      image: 'assets/images/mango.png',
      images: []),
  Item(
      productId: '003',
      category: 'fruits',
      name: 'Banana',
      unit: 'Doz',
      price: 10,
      image: 'assets/images/banana.png',
      images: []),

  Item(
      productId: '102', category: 'electronic',
      name: 'MacBook Pro Retina 13" i5 2.8GHz 8GB 128GB MID-2014 - A1502 - GRADE C-\', '
          'unit: \'number\', price: 599',
      unit: 'number', price: 35,
      image: 'assets/images/set2/s-l501_002.jpg',
      images: [
        'assets/images/set2/s-l501_002.jpg',
        'assets/images/set2/s-l501_003.jpg',
        'assets/images/set2/s-l501_004.jpg',
        'assets/images/set2/s-l501_005.jpg',
        'assets/images/set2/s-l501_006.jpg',
        'assets/images/set2/s-l501_007.jpg',
        'assets/images/set2/s-l501_008.jpg',
        'assets/images/set2/s-l501_009.jpg',
      ]),

  Item(
      productId: '004',
      category: 'fruits',
      name: 'Grapes',
      unit: 'Kg',
      price: 8,
      image: 'assets/images/grapes.png',
      images: []),
  Item(
      productId: '103', category: 'electronic',
      name: 'Apple MacBook Pro Retina 13" Core i5 2.9Ghz 8GB 256GB Flash (April 2015) B Grade '
          '12M Warranty, MF841LL,Best Selling, Office 365, Charger',
      unit: 'number', price: 113,
      image: 'assets/images/set2/s-l502_001.png',
      images: [
        'assets/images/set2/s-l502_001.png',
        'assets/images/set2/s-l502_002.jpg',
        'assets/images/set2/s-l502_003.jpg',
        'assets/images/set2/s-l502_004.jpg',
        'assets/images/set2/s-l502_005.jpg',
        'assets/images/set2/s-l502_006.jpg',
      ]),

  Item(
      productId: '005',
      category: 'fruits',
      name: 'Water Melon',
      unit: 'Kg',
      price: 25,
      image: 'assets/images/watermelon.png',
      images: []),
  Item(productId: '006',  category: 'fruits', name: 'Kiwi', unit: 'Pc', price: 40, image: 'assets/images/kiwi.png',images: []),
  Item(
      productId: '007',
      category: 'fruits',
      name: 'Orange',
      unit: 'Doz',
      price: 15,
      image: 'assets/images/orange.png',
      images: []),
  Item(productId: '008',  category: 'fruits', name: 'Peach', unit: 'Pc', price: 8, image: 'assets/images/peach.png',images: []),
  Item(
      productId: '009',
      category: 'fruits',
      name: 'Strawberry',
      unit: 'Box',
      price: 12,
      image: 'assets/images/strawberry.png',
      images: []),
  Item(
      productId: '010',
      category: 'fruits',
      name: 'Fruit Basket',
      unit: 'Kg',
      price: 55,
      image: 'assets/images/fruitBasket.png',
      images: []),

  Item(
      productId: '104', category: 'electronic',
      name: 'Armaf Niche Purple Amethyst EDP For Women 90ml',
      unit: 'number', price: 11,
      image: 'assets/images/set2/s-l503_001.png',
      images: []),
];

final assets = const [
  Image(image: AssetImage('assets/images/kiwi.png')),
  Image(image: AssetImage('assets/images/peach.png')),
  Image(image: AssetImage('assets/images/apple.png')),
  Image(image: AssetImage('assets/images/watermelon.png')),
];

final List<String> astImgList = const [
  'assets/images/set2/img001.png',
  'assets/images/set2/img002.png',
  'assets/images/set2/img003.png',
  'assets/images/set2/img004.png',
  'assets/images/kiwi.png',
  'assets/images/peach.png',
  'assets/images/apple.png',
  'assets/images/watermelon.png',
];

final List<String> netImgList = const [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

String getCatByPID(String pid){
  String cat = "fruits";
  //List<Item> products = data.products;
  products.forEach((element) {
    if(pid==element.productId){
      cat = element.category;
    }
  });
  return cat;
}

