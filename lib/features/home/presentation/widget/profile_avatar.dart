import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final Color? borderColor;

  final Function()? onPressed;

  const ProfileAvatar({
    Key? key,
    this.onPressed,
    this.radius = 50.0,
    required this.imageUrl,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            width: 1, color: borderColor ?? Colors.grey.withOpacity(.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500.0),
        child: (imageUrl.isEmpty)
            ? Image.asset('assets/images/profile.jpg')
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  size: radius * .5,
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
