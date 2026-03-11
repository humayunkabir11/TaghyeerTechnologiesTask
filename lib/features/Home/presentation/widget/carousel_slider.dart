import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hrx/core/config/util/style.dart';
import 'package:hrx/core/custom_assets/assets.gen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/config/color/custom_color.dart';

class CarouselSlider extends StatefulWidget {
  final List<dynamic> sliderList;

  const CarouselSlider({super.key, this.sliderList = const [1, 2, 3, 4, 5]});

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late PageController _controller;
  int _page = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = PageController(
      initialPage: 1,
      viewportFraction: 0.90, // show previous/next items partially
    );

    _startCarousel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _carouselTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_controller.hasClients) return;
      final count = widget.sliderList.length;
      _page = (_page + 1) % count;

      _controller.animateToPage(
        _page,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _carouselTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _startCarousel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160, // a little taller to allow scaling
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.sliderList.length,
            onPageChanged: (currentPage) {
              setState(() => _page = currentPage);
            },
            itemBuilder: (context, index) {
              double scale = 0.85;
              if (_controller.hasClients &&
                  _controller.position.haveDimensions) {
                double page =
                    _controller.page ?? _controller.initialPage.toDouble();
                scale = (1 - (page - index).abs() * 0.15).clamp(0.85, 1.0);
              }

              return TweenAnimationBuilder(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: scale, end: scale),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.7, 1.0),
                      child: child,
                    ),
                  );
                },
                child: _buildCard(),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _controller,
          count: widget.sliderList.length,
          effect: const ExpandingDotsEffect(
            dotColor: AppColors.primaryColor,
            activeDotColor: AppColors.primaryColor,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
            spacing: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(
            color: Color(0x1E17598B),
            blurRadius: 12,
            offset: Offset(0, 0),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.icons.icannouncement.svg(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Full day office on Next Sunday",
                  style: latoBold.copyWith(
                    color: AppColors.primaryTextColor,
                    fontSize: 16,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Divider(
                  color: AppColors.primaryTextColor,
                  thickness: 1,
                  height: 8,
                ),
                Text(
                  "Lorem ipsum dolor sit amet consectetur. Augue semper adipiscing eget nibh varius amet purus varius amet purus",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: latoLight.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                    color: AppColors.primaryTextColor,
                  ),
                ),

                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Assets.icons.icCalendar.svg(
                        height: 14,
                        width: 14,
                        colorFilter: ColorFilter.mode(
                          const Color(0xFF17598B),
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        "Dec 12, 2025",
                        style: latoRegular.copyWith(
                          fontSize: 12,
                          letterSpacing: 0,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
