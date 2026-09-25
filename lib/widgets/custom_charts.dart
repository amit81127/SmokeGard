import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExposureTrendLineChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color lineColor;
  final double height;

  const ExposureTrendLineChart({
    super.key,
    required this.values,
    required this.labels,
    this.lineColor = AppColors.accentCyan,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size.infinite,
        painter: _LineChartPainter(
          values: values,
          labels: labels,
          lineColor: lineColor,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color lineColor;

  _LineChartPainter({
    required this.values,
    required this.labels,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final paddingBottom = 24.0;
    final paddingTop = 10.0;
    final paddingLeft = 8.0;
    final paddingRight = 8.0;
    final chartHeight = size.height - paddingBottom - paddingTop;
    final chartWidth = size.width - paddingLeft - paddingRight;

    final maxValue = (values.reduce(max) * 1.2).clamp(10.0, 150.0);
    final dx = chartWidth / (values.length - 1);

    // Grid lines
    final gridPaint = Paint()
      ..color = AppColors.darkBorder.withValues(alpha: 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 3; i++) {
      final y = paddingTop + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
    }

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = paddingLeft + i * dx;
      final y = paddingTop + chartHeight - (values[i] / maxValue) * chartHeight;
      points.add(Offset(x, y));
    }

    // Gradient fill under the curve
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY1 = p0.dy;
      final controlX2 = p0.dx + (p1.dx - p0.dx) / 2;
      final controlY2 = p1.dy;
      path.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, paddingTop + chartHeight)
      ..lineTo(points.first.dx, paddingTop + chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          lineColor.withValues(alpha: 0.35),
          lineColor.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Line stroke
    final strokePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Point dots & X Labels
    final textStyle = const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      canvas.drawCircle(p, 3.5, Paint()..color = AppColors.darkBg);
      canvas.drawCircle(p, 2.5, Paint()..color = lineColor);

      if (i < labels.length) {
        final textSpan = TextSpan(text: labels[i], style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(p.dx - textPainter.width / 2, size.height - 16),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => true;
}

class RiskDonutChart extends StatelessWidget {
  final double safePercent;
  final double moderatePercent;
  final double highPercent;
  final double size;

  const RiskDonutChart({
    super.key,
    required this.safePercent,
    required this.moderatePercent,
    required this.highPercent,
    this.size = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _DonutChartPainter(
                  safe: safePercent,
                  moderate: moderatePercent,
                  high: highPercent,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(safePercent * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Clean Air',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendRow('Safe Air', safePercent, AppColors.riskSafe),
              const SizedBox(height: 8),
              _buildLegendRow('Moderate', moderatePercent, AppColors.riskModerate),
              const SizedBox(height: 8),
              _buildLegendRow('High Hazard', highPercent, AppColors.riskHigh),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendRow(String label, double fraction, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          '${(fraction * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double safe;
  final double moderate;
  final double high;

  _DonutChartPainter({
    required this.safe,
    required this.moderate,
    required this.high,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 12.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -pi / 2;

    // Safe arc
    final safeSweep = safe * 2 * pi;
    paint.color = AppColors.riskSafe;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, safeSweep, false, paint);
    startAngle += safeSweep;

    // Moderate arc
    final moderateSweep = moderate * 2 * pi;
    paint.color = AppColors.riskModerate;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, moderateSweep, false, paint);
    startAngle += moderateSweep;

    // High arc
    final highSweep = high * 2 * pi;
    paint.color = AppColors.riskHigh;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, highSweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => true;
}

class WeeklyExposureBarChart extends StatelessWidget {
  final List<double> dailyMinutes;
  final List<String> dayLabels;
  final int activeIndex;
  final double height;

  const WeeklyExposureBarChart({
    super.key,
    required this.dailyMinutes,
    required this.dayLabels,
    this.activeIndex = 0,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = (dailyMinutes.isEmpty ? 60.0 : dailyMinutes.reduce(max) * 1.15).clamp(30.0, 120.0);

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(dailyMinutes.length, (index) {
          final minutes = dailyMinutes[index];
          final heightFactor = (minutes / maxVal).clamp(0.08, 1.0);
          final isHighlighted = index == activeIndex;
          final color = isHighlighted
              ? AppColors.accentCyan
              : (minutes > 50 ? AppColors.riskHigh : AppColors.darkBorder);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${minutes.toInt()}m',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isHighlighted
                          ? AppColors.accentCyan
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: (height - 40) * heightFactor,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: isHighlighted
                          ? [
                              BoxShadow(
                                color: AppColors.accentCyan.withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayLabels[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w500,
                      color: isHighlighted
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
