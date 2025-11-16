import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user_model.dart';
import '../widgets/user_detail_card.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  double _scrollOffset = 0.0;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(_onScroll);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      final newIsCollapsed = _scrollOffset > 120;
      if (newIsCollapsed != _isCollapsed) {
        _isCollapsed = newIsCollapsed;
        if (_isCollapsed) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.surfaceContainerLow,
      body: Stack(
        children: [
          const _DetailBackground(),
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 340,
                elevation: 0,
                backgroundColor: _isCollapsed
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                pinned: true,
                automaticallyImplyLeading: false,
                systemOverlayStyle: Theme.of(
                  context,
                ).appBarTheme.systemOverlayStyle,
                leading: _buildBackButton(),
                actions: [
                  _buildAnimatedActionButtons(),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Avatar
                          Hero(
                            tag: 'user_avatar_${widget.user.email}',
                            child: _buildAvatar(),
                          ),
                          const SizedBox(height: 16),
                          // Name
                          _buildNameSection(context),
                          const SizedBox(height: 20),
                          // Action buttons (visible when expanded)
                          AnimatedBuilder(
                            animation: _fadeAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _fadeAnimation.value,
                                child: Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: _buildExpandedActionButtons(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: UserDetailCard(
                    user: widget.user,
                    showActionButtons: false, // Hide action buttons in card
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _isCollapsed
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildAnimatedActionButtons() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: _isCollapsed ? 120 : 0,
          height: 56,
          child: _isCollapsed
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildCollapsedActionButton(
                icon: Icons.email_rounded,
                onPressed: () => _launchEmail(context, widget.user.email),
              ),
              const SizedBox(width: 4),
              _buildCollapsedActionButton(
                icon: Icons.call_rounded,
                onPressed: () => _launchCall(context, widget.user.phoneNumber),
              ),
              const SizedBox(width: 8),
            ],
          )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildCollapsedActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(icon, color: Colors.white, size: 20),
              onPressed: onPressed,
              tooltip: icon == Icons.email_rounded ? 'Send Email' : 'Call Now',
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 80 : 120,
      height: _isCollapsed ? 80 : 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 4,
        ),
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white.withOpacity(0.2),
        backgroundImage: widget.user.avatar.isNotEmpty
            ? NetworkImage(widget.user.avatar)
            : null,
        child: widget.user.avatar.isEmpty
            ? const Icon(
          Icons.person_rounded,
          size: 56,
          color: Colors.white,
        )
            : null,
      ),
    );
  }

  Widget _buildNameSection(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isCollapsed ? 0.0 : 1.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.user.fullName,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '@${widget.user.email.split('@').first}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildExpandedActionButton(
              context,
              icon: Icons.email_rounded,
              label: 'Send Email',
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              onPressed: () => _launchEmail(context, widget.user.email),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildExpandedActionButton(
              context,
              icon: Icons.call_rounded,
              label: 'Call Now',
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              onPressed: () => _launchCall(context, widget.user.phoneNumber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Gradient gradient,
        required VoidCallback onPressed,
      }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradient,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await _launchUri(context, uri);
  }

  Future<void> _launchCall(BuildContext context, String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    await _launchUri(context, uri);
  }

  Future<void> _launchUri(BuildContext context, Uri uri) async {
    HapticFeedback.lightImpact();
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        if (context.mounted) _showLaunchError(context);
      }
    } catch (_) {
      if (context.mounted) _showLaunchError(context);
    }
  }

  void _showLaunchError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 10),
            Text(
              'Unable to open app',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.red.shade400,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8F9FF), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -30,
            child: _blurredCircle(120, Theme.of(context).colorScheme.primary),
          ),
          Positioned(
            bottom: 120,
            right: -40,
            child: _blurredCircle(160, AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _blurredCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.08),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}