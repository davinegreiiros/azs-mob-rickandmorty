import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SkeletonEpisodeList extends StatefulWidget {
  final int count;
  const SkeletonEpisodeList({super.key, this.count = 6});

  @override
  State<SkeletonEpisodeList> createState() => _SkeletonEpisodeListState();
}

class _SkeletonEpisodeListState extends State<SkeletonEpisodeList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat(reverse: true);

  late final Animation<double> _fade = Tween<double>(begin: 0.35, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: widget.count,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const _SkeletonEpisodeCard(),
      ),
    );
  }
}

class _SkeletonEpisodeCard extends StatelessWidget {
  const _SkeletonEpisodeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bone(width: 62, height: 20, radius: 6),
                SizedBox(height: 8),
                _Bone(width: double.infinity, height: 15, radius: 6),
                SizedBox(height: 5),
                _Bone(width: 140, height: 15, radius: 6),
                SizedBox(height: 10),
                Row(
                  children: [
                    _Bone(width: 14, height: 14, radius: 4),
                    SizedBox(width: 6),
                    _Bone(width: 88, height: 12, radius: 4),
                    SizedBox(width: 14),
                    _Bone(width: 14, height: 14, radius: 4),
                    SizedBox(width: 6),
                    _Bone(width: 72, height: 12, radius: 4),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          _Bone(width: 40, height: 40, radius: 20),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _Bone({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
