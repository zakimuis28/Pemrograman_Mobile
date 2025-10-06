import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientScaffold(
      title: 'Halaman Home',
      emoji: '🏠',
      info:
          'Selamat datang di aplikasi demo navigasi gaya Gen Z! '
          'Kamu bisa eksplor desain yang estetik, warna neon, dan efek glassmorphism yang kekinian. '
          'Tekan tombol di bawah untuk lanjut ke halaman tujuan 🌈',
      primaryActionLabel: 'Ke Halaman Tujuan →',
      onPrimaryTap: () => Navigator.pushNamed(context, '/tujuan'),
    );
  }
}

// Widget utama dengan efek gradasi + AppBar transparan + blob dekoratif
class AnimatedGradientScaffold extends StatelessWidget {
  const AnimatedGradientScaffold({
    super.key,
    required this.title,
    required this.emoji,
    required this.info,
    required this.primaryActionLabel,
    required this.onPrimaryTap,
    this.secondaryActionLabel,
    this.onSecondaryTap,
    this.flip = false,
  });

  final String title;
  final String emoji;
  final String info;
  final String primaryActionLabel;
  final VoidCallback onPrimaryTap;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryTap;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: Navigator.of(context).canPop()
            ? const BackButton(color: Colors.white)
            : null,
        backgroundColor: Colors.white.withOpacity(0.12),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0, end: 1),
        builder: (context, t, _) {
          final colors = [
            Color.lerp(const Color(0xFF6A5AE0), const Color(0xFF00D1FF), flip ? 1 - t : t)!,
            Color.lerp(const Color(0xFFFF7AD9), const Color(0xFF00FFA3), flip ? t : 1 - t)!,
          ];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: -80,
                    left: -40,
                    child: _Blob(color: Colors.white.withOpacity(0.18), size: 220)),
                Positioned(
                    bottom: -60,
                    right: -30,
                    child: _Blob(color: Colors.black.withOpacity(0.12), size: 180)),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: 'main-emoji',
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Colors.white.withOpacity(0.2),
                                border:
                                    Border.all(color: Colors.white.withOpacity(0.25)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  )
                                ],
                              ),
                              child: Text(emoji,
                                  style: const TextStyle(fontSize: 88, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 22),
                          _GlassCard(text: info),
                          const SizedBox(height: 24),
                          GradientButton(label: primaryActionLabel, onTap: onPrimaryTap),
                          if (secondaryActionLabel != null) ...[
                            const SizedBox(height: 12),
                            OutlineGlassButton(
                                label: secondaryActionLabel!, onTap: onSecondaryTap!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 40),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.5, height: 1.4, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A00), Color(0xFFFF3D81)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF3D81).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineGlassButton extends StatelessWidget {
  const OutlineGlassButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: BorderSide(color: Colors.white.withOpacity(0.65), width: 1.2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child:
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
