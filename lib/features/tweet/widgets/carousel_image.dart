import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({super.key, required this.imageLinks});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
            items: widget.imageLinks
                .map((link) => Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: Image.network(
                      link,
                      fit: BoxFit.contain,
                    )))
                .toList(),
            options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                height: 400,
                enableInfiniteScroll: false,
                viewportFraction: 1)),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: widget.imageLinks.asMap().entries.map((e) {
            return Container(
              height: 12,
              width: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Pallete.whiteColor
                      .withOpacity(_currentIndex == e.key ? 0.9 : 0.4)),
            );
          }).toList(),
        )
      ],
    );
  }
}
