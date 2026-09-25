import 'dart:math';
import 'package:flutter/material.dart';
import '../models/smoke_data.dart';
import '../theme/app_theme.dart';

class RiskGaugeWidget extends StatelessWidget {
  final int pseiScore;
  final RiskLevel riskLevel;
  final double size;

  const RiskGaugeWidget({
    super.key,
    required this.pseiScore,
    required this.riskLevel,
    this.size = 240,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size * 0.85,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(size, size * 0.85),
              painter: _RiskGaugePainter(
                pseiScore: pseiScore,
                riskColor: riskLevel.color,
              ),
            ),
            Positioned(
              bottom: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PSEI: $pseiScore',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: riskLevel.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: riskLevel.color, width: 1),
                    ),
                    child: Text(
                      riskLevel.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: riskLevel.color,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Personal Smoke Exposure Index',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskGaugePainter extends CustomPainter {
  final int pseiScore;
  final Color riskColor;

  _RiskGaugePainter({
    required this.pseiScore,
    required this.riskColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.65);
    final radius = size.width * 0.40;
    const startAngle = pi * 0.8;
    const sweepAngle = pi * 1.4;

    // Track Background Arc
    final bgPaint = Paint()
      ..color = AppColors.darkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Active Gradient Arc
    final progressFraction = (pseiScore / 100.0).clamp(0.0, 1.0);
    final activeSweep = sweepAngle * progressFraction;

    final gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: const [
          AppColors.accentCyan,
          AppColors.riskModerate,
          AppColors.riskHigh,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeSweep,
      false,
      gradientPaint,
    );

    // Needle Indicator Pointer
    final needleAngle = startAngle + activeSweep;
    final needleLength = radius + 4;
    final needleX = center.dx + needleLength * cos(needleAngle);
    final needleY = center.dy + needleLength * sin(needleAngle);

    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.accentCyan.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(Offset(needleX, needleY), 10, glowPaint);
    canvas.drawCircle(Offset(needleX, needleY), 7, needlePaint);
    canvas.drawCircle(Offset(needleX, needleY), 4, Paint()..color = riskColor);
  }

  @override
  bool shouldRepaint(covariant _RiskGaugePainter oldDelegate) {
    return oldDelegate.pseiScore != pseiScore ||
        oldDelegate.riskColor != riskColor;
  }
}
